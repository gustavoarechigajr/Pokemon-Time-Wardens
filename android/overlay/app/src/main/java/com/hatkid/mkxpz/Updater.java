package com.hatkid.mkxpz;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInstaller;
import android.os.Build;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.zip.CRC32;
import java.util.zip.GZIPInputStream;
import java.util.zip.Inflater;

/**
 * In-app updates, served from the GitHub release the CI publishes
 * (see .github/workflows/android-apk.yml):
 *
 *   version.json            build number, game id, engine id, sizes
 *   game-manifest.json.gz   every game file: CRC, size and byte range in game.zip
 *   game.zip                the packaged game (same file the full APK bundles)
 *   TimeWardens-update.apk  the app without the bundled game (engine updates)
 *
 * Game updates download only the files whose CRC/size changed, using HTTP
 * range requests into game.zip. Engine updates install the small update APK
 * over the current app, which keeps the game files and saves.
 */
public class Updater
{
    private static final String TAG = "TimeWardens[Update]";
    static final String MANIFEST_NAME = ".tw_manifest.json.gz";

    public interface Progress
    {
        void onProgress(String message, long done, long total);
    }

    public static class Info
    {
        public int build;
        public String gameId;
        public String engineId;
        public int apkVersionCode;
        public long updateApkBytes;
    }

    public static class Plan
    {
        final List<Object[]> changed = new ArrayList<>();
        final List<String> removed = new ArrayList<>();
        byte[] manifestBytes;
        int build;
        long downloadBytes;

        public int fileCount() { return changed.size(); }
        public long bytes() { return downloadBytes; }
        public boolean isEmpty() { return changed.isEmpty() && removed.isEmpty(); }
    }

    private final Context mContext;
    private final String mBaseUrl;
    private final String mEngineId;

    public Updater(Context context)
    {
        mContext = context;
        Properties p = new Properties();
        try (InputStream in = context.getAssets().open("engine.properties")) {
            p.load(in);
        } catch (IOException e) {
            Log.w(TAG, "No engine.properties: updates disabled");
        }
        String repo = p.getProperty("repo", "");
        String tag = p.getProperty("tag", "android-latest");
        mBaseUrl = repo.isEmpty() ? null : "https://github.com/" + repo + "/releases/download/" + tag + "/";
        mEngineId = p.getProperty("engine_id", "");
    }

    public boolean enabled() { return mBaseUrl != null; }
    public String engineId() { return mEngineId; }

    // ------------------------------------------------------------------ http

    private HttpURLConnection open(String url, int timeoutMs) throws IOException
    {
        HttpURLConnection c = (HttpURLConnection) new URL(url).openConnection();
        c.setConnectTimeout(timeoutMs);
        c.setReadTimeout(Math.max(timeoutMs, 30000));
        c.setRequestProperty("User-Agent", "TimeWardens-Android");
        c.setInstanceFollowRedirects(true);
        return c;
    }

    private byte[] readAll(InputStream in, long expected) throws IOException
    {
        ByteArrayOutputStream bos = new ByteArrayOutputStream(expected > 0 ? (int) Math.min(expected, 64 << 20) : 1 << 16);
        byte[] buf = new byte[1 << 16];
        int n;
        while ((n = in.read(buf)) > 0) bos.write(buf, 0, n);
        return bos.toByteArray();
    }

    private byte[] get(String name, int timeoutMs) throws IOException
    {
        HttpURLConnection c = open(mBaseUrl + name, timeoutMs);
        try {
            int code = c.getResponseCode();
            if (code != 200) throw new IOException("HTTP " + code + " for " + name);
            try (InputStream in = c.getInputStream()) {
                return readAll(in, contentLength(c));
            }
        } finally {
            c.disconnect();
        }
    }

    private static long contentLength(HttpURLConnection c)
    {
        try {
            return Long.parseLong(c.getHeaderField("Content-Length"));
        } catch (Exception e) {
            return -1;
        }
    }

    /** Resolves the release asset's redirect once so ranges go straight to storage. */
    private String resolve(String name) throws IOException
    {
        HttpURLConnection c = open(mBaseUrl + name, 15000);
        c.setInstanceFollowRedirects(false);
        c.setRequestMethod("HEAD");
        try {
            int code = c.getResponseCode();
            String loc = c.getHeaderField("Location");
            if (code >= 300 && code < 400 && loc != null) return loc;
            return mBaseUrl + name;
        } finally {
            c.disconnect();
        }
    }

    private byte[] getRange(String url, long start, long endInclusive) throws IOException
    {
        HttpURLConnection c = open(url, 20000);
        c.setRequestProperty("Range", "bytes=" + start + "-" + endInclusive);
        try {
            int code = c.getResponseCode();
            if (code != 206) throw new IOException("range request: HTTP " + code);
            try (InputStream in = c.getInputStream()) {
                byte[] data = readAll(in, endInclusive - start + 1);
                if (data.length != endInclusive - start + 1) throw new IOException("short range read");
                return data;
            }
        } finally {
            c.disconnect();
        }
    }

    // ----------------------------------------------------------------- check

    /** Fetches version.json; returns null when offline or updates are off. */
    public Info check()
    {
        if (!enabled()) return null;
        try {
            JSONObject j = new JSONObject(new String(get("version.json", 5000), StandardCharsets.UTF_8));
            Info i = new Info();
            i.build = j.optInt("build", 0);
            i.gameId = j.optString("game_id", "");
            i.engineId = j.optString("engine_id", "");
            i.apkVersionCode = j.optInt("apk_version_code", 0);
            i.updateApkBytes = j.optLong("update_apk_bytes", 0);
            return i;
        } catch (Exception e) {
            Log.i(TAG, "Update check skipped: " + e);
            return null;
        }
    }

    // ---------------------------------------------------------- game update

    private static Map<String, Object[]> parseManifest(byte[] gz) throws Exception
    {
        byte[] json;
        try (GZIPInputStream in = new GZIPInputStream(new java.io.ByteArrayInputStream(gz))) {
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            byte[] buf = new byte[1 << 16];
            int n;
            while ((n = in.read(buf)) > 0) bos.write(buf, 0, n);
            json = bos.toByteArray();
        }
        JSONArray files = new JSONObject(new String(json, StandardCharsets.UTF_8)).getJSONArray("files");
        Map<String, Object[]> map = new HashMap<>(files.length() * 2);
        for (int i = 0; i < files.length(); i++) {
            JSONArray f = files.getJSONArray(i);
            map.put(f.getString(0), new Object[] {
                f.getString(0), f.getLong(1), f.getLong(2), f.getLong(3), f.getLong(4), f.getInt(5) });
        }
        return map;
    }

    static byte[] readFile(File f) throws IOException
    {
        try (FileInputStream in = new FileInputStream(f)) {
            byte[] data = new byte[(int) f.length()];
            int n = 0, r;
            while (n < data.length && (r = in.read(data, n, data.length - n)) > 0) n += r;
            return data;
        }
    }

    /** Works out which game files differ from the published build. */
    public Plan plan(File gameDir, int build) throws Exception
    {
        Plan plan = new Plan();
        plan.build = build;
        plan.manifestBytes = get("game-manifest.json.gz", 15000);
        Map<String, Object[]> remote = parseManifest(plan.manifestBytes);

        Map<String, Object[]> local = new HashMap<>();
        File localManifest = new File(gameDir, MANIFEST_NAME);
        if (localManifest.isFile()) {
            try {
                local = parseManifest(readFile(localManifest));
            } catch (Exception e) {
                Log.w(TAG, "Local manifest unreadable, updating everything: " + e);
            }
        }

        for (Object[] r : remote.values()) {
            Object[] l = local.get((String) r[0]);
            boolean present = l != null && ((Long) l[1]).equals(r[1]) && ((Long) l[2]).equals(r[2])
                && new File(gameDir, (String) r[0]).isFile();
            if (!present) {
                plan.changed.add(r);
                plan.downloadBytes += (Long) r[4];
            }
        }
        for (String path : local.keySet()) {
            if (!remote.containsKey(path)) plan.removed.add(path);
        }
        // Download in archive order so neighbouring files share range requests
        java.util.Collections.sort(plan.changed, (a, b) -> Long.compare((Long) a[3], (Long) b[3]));
        Log.i(TAG, "Update plan: " + plan.changed.size() + " files (" + plan.downloadBytes + " bytes), "
            + plan.removed.size() + " removed");
        return plan;
    }

    /** Downloads and installs the planned files; throws on any failure. */
    public void apply(File gameDir, Plan plan, Progress progress) throws Exception
    {
        String canonicalRoot = gameDir.getCanonicalPath() + File.separator;
        String url = resolve("game.zip");
        long done = 0;
        final long MAX_GAP = 256 * 1024, MAX_SPAN = 16L << 20;

        int i = 0;
        while (i < plan.changed.size()) {
            // Group neighbouring entries into one range request
            int j = i;
            long start = (Long) plan.changed.get(i)[3];
            long end = start + (Long) plan.changed.get(i)[4];
            while (j + 1 < plan.changed.size()) {
                Object[] next = plan.changed.get(j + 1);
                long ns = (Long) next[3], ne = ns + (Long) next[4];
                if (ns - end > MAX_GAP || ne - start > MAX_SPAN) break;
                end = Math.max(end, ne);
                j++;
            }

            byte[] block;
            try {
                block = end > start ? getRange(url, start, end - 1) : new byte[0];
            } catch (IOException e) {
                // Signed storage URLs expire; resolve again and retry once
                url = resolve("game.zip");
                block = end > start ? getRange(url, start, end - 1) : new byte[0];
            }

            for (int k = i; k <= j; k++) {
                Object[] f = plan.changed.get(k);
                String path = (String) f[0];
                long crc = (Long) f[1], size = (Long) f[2], off = (Long) f[3], csize = (Long) f[4];
                int method = (Integer) f[5];
                byte[] data = java.util.Arrays.copyOfRange(block, (int) (off - start), (int) (off - start + csize));
                if (method == 8) {
                    Inflater inf = new Inflater(true);
                    inf.setInput(data);
                    byte[] out = new byte[(int) size];
                    int n = 0;
                    while (n < out.length && !inf.finished()) {
                        int r = inf.inflate(out, n, out.length - n);
                        if (r == 0 && (inf.needsInput() || inf.needsDictionary())) break;
                        n += r;
                    }
                    inf.end();
                    if (n != size) throw new IOException("bad data for " + path);
                    data = out;
                } else if (method != 0) {
                    throw new IOException("unsupported compression for " + path);
                }
                CRC32 c = new CRC32();
                c.update(data);
                if (c.getValue() != crc || data.length != size) throw new IOException("checksum mismatch for " + path);

                File target = new File(gameDir, path);
                if (!target.getCanonicalPath().startsWith(canonicalRoot)) throw new IOException("bad path " + path);
                File parent = target.getParentFile();
                if (parent != null && !parent.isDirectory() && !parent.mkdirs()) throw new IOException("cannot create " + parent);
                File tmp = new File(target.getPath() + ".twtmp");
                try (OutputStream os = new FileOutputStream(tmp)) {
                    os.write(data);
                }
                if (target.exists() && !target.delete()) throw new IOException("cannot replace " + path);
                if (!tmp.renameTo(target)) throw new IOException("cannot write " + path);

                done += csize;
                progress.onProgress("Downloading update... " + (k + 1) + " / " + plan.changed.size() + " files",
                    done, Math.max(1, plan.downloadBytes));
            }
            i = j + 1;
        }

        for (String path : plan.removed) {
            File f = new File(gameDir, path);
            if (f.getCanonicalPath().startsWith(canonicalRoot)) f.delete();
        }

        // Record what is installed now
        try (OutputStream os = new FileOutputStream(new File(gameDir, MANIFEST_NAME))) {
            os.write(plan.manifestBytes);
        }
        Log.i(TAG, "Game updated to build " + plan.build);
    }

    // ----------------------------------------------------------- app update

    /**
     * Downloads the update APK and hands it to the system installer, which
     * asks the user to confirm. The app restarts after installing.
     */
    public void installAppUpdate(Info info, Progress progress) throws Exception
    {
        File apk = new File(mContext.getCacheDir(), "update.apk");
        HttpURLConnection c = open(mBaseUrl + "TimeWardens-update.apk", 15000);
        try {
            if (c.getResponseCode() != 200) throw new IOException("HTTP " + c.getResponseCode());
            long total = Math.max(1, contentLength(c));
            try (InputStream in = c.getInputStream(); OutputStream os = new FileOutputStream(apk)) {
                byte[] buf = new byte[1 << 16];
                long done = 0;
                int n;
                while ((n = in.read(buf)) > 0) {
                    os.write(buf, 0, n);
                    done += n;
                    progress.onProgress("Downloading app update...", done, total);
                }
            }
        } finally {
            c.disconnect();
        }

        PackageInstaller installer = mContext.getPackageManager().getPackageInstaller();
        PackageInstaller.SessionParams params = new PackageInstaller.SessionParams(PackageInstaller.SessionParams.MODE_FULL_INSTALL);
        params.setAppPackageName(mContext.getPackageName());
        int sessionId = installer.createSession(params);
        try (PackageInstaller.Session session = installer.openSession(sessionId)) {
            try (InputStream in = new FileInputStream(apk); OutputStream out = session.openWrite("update.apk", 0, apk.length())) {
                byte[] buf = new byte[1 << 16];
                int n;
                while ((n = in.read(buf)) > 0) out.write(buf, 0, n);
                session.fsync(out);
            }
            Intent intent = new Intent(mContext, GameInstallActivity.class);
            intent.setAction(GameInstallActivity.ACTION_INSTALL_STATUS);
            int flags = PendingIntent.FLAG_UPDATE_CURRENT;
            if (Build.VERSION.SDK_INT >= 31) flags |= PendingIntent.FLAG_MUTABLE;
            PendingIntent pi = PendingIntent.getActivity(mContext, 0, intent, flags);
            session.commit(pi.getIntentSender());
        }
        apk.delete();
    }
}
