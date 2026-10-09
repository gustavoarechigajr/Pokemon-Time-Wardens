package com.hatkid.mkxpz;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.StatFs;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

/**
 * Launcher activity for the bundled game.
 *
 * The game (scripts, data, graphics, audio) ships inside the APK as
 * assets/game.zip. Pokemon Essentials loads its scripts with plain Ruby file
 * I/O, so the files have to exist on a real filesystem. On first launch (and
 * after every app update) this activity unpacks game.zip into the app's own
 * external files directory, then hands over to MainActivity, which runs the
 * mkxp-z engine from there.
 *
 * Saves are not stored here: mkxp-z keeps them in the internal data
 * directory (System.data_directory), so reinstalling the game files never
 * touches them.
 */
public class GameInstallActivity extends Activity
{
    private static final String TAG = "TimeWardens[Install]";
    private static final String GAME_ASSET = "game.zip";
    private static final String GAME_INFO_ASSET = "game.properties";
    private static final String MARKER_FILE = ".installed";
    private static final String PREFS = "install";

    private ProgressBar mProgress;
    private TextView mStatus;
    private volatile boolean mCancelled = false;

    /** Directory the game is unpacked into (shared with MainActivity). */
    public static File getGameDir(Context ctx)
    {
        // App-specific external storage needs no permission and lives on the
        // emulated (case-insensitive) storage, like a Windows install would.
        File base = ctx.getExternalFilesDir(null);
        if (base == null) {
            base = ctx.getFilesDir();
        }
        return new File(base, "game");
    }

    /** Identifies the bundled game build; changes on every APK update. */
    private String getBuildStamp()
    {
        try {
            PackageInfo info = getPackageManager().getPackageInfo(getPackageName(), 0);
            return info.versionName + "/" + info.lastUpdateTime + "/" + readGameInfo().getProperty("id", "");
        } catch (Exception e) {
            return "unknown";
        }
    }

    private Properties readGameInfo()
    {
        Properties p = new Properties();
        try (InputStream in = getAssets().open(GAME_INFO_ASSET)) {
            p.load(in);
        } catch (IOException e) {
            Log.w(TAG, "No " + GAME_INFO_ASSET + " in assets: " + e);
        }
        return p;
    }

    private boolean isInstalled(File gameDir, String stamp)
    {
        SharedPreferences prefs = getSharedPreferences(PREFS, MODE_PRIVATE);
        return stamp.equals(prefs.getString("stamp", null))
            && new File(gameDir, MARKER_FILE).isFile()
            && new File(gameDir, "Game.ini").isFile();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        final File gameDir = getGameDir(this);
        final String stamp = getBuildStamp();

        if (isInstalled(gameDir, stamp)) {
            launchGame();
            return;
        }

        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        buildUi();

        new Thread(() -> install(gameDir, stamp), "game-install").start();
    }

    @Override
    protected void onDestroy()
    {
        mCancelled = true;
        super.onDestroy();
    }

    private void buildUi()
    {
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setGravity(Gravity.CENTER);
        root.setBackgroundColor(Color.rgb(0x20, 0x20, 0x2a));
        int pad = dp(32);
        root.setPadding(pad, pad, pad, pad);

        TextView title = new TextView(this);
        title.setText(getApplicationInfo().loadLabel(getPackageManager()));
        title.setTextColor(Color.WHITE);
        title.setTextSize(TypedValue.COMPLEX_UNIT_SP, 26);
        title.setGravity(Gravity.CENTER);
        root.addView(title);

        mStatus = new TextView(this);
        mStatus.setText("Preparing game files (first launch only)...");
        mStatus.setTextColor(Color.LTGRAY);
        mStatus.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16);
        mStatus.setGravity(Gravity.CENTER);
        mStatus.setPadding(0, dp(16), 0, dp(16));
        root.addView(mStatus);

        mProgress = new ProgressBar(this, null, android.R.attr.progressBarStyleHorizontal);
        mProgress.setMax(1000);
        mProgress.setIndeterminate(false);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(dp(360), LinearLayout.LayoutParams.WRAP_CONTENT);
        root.addView(mProgress, lp);

        setContentView(root);
    }

    private int dp(int v)
    {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, v, getResources().getDisplayMetrics());
    }

    private void setStatus(final String text, final int permille)
    {
        runOnUiThread(() -> {
            if (mStatus != null) mStatus.setText(text);
            if (mProgress != null && permille >= 0) mProgress.setProgress(permille);
        });
    }

    private void install(File gameDir, String stamp)
    {
        try {
            Properties info = readGameInfo();
            long totalBytes = Long.parseLong(info.getProperty("uncompressed_bytes", "0"));

            // Remove any previous (possibly partial or outdated) copy first so
            // files deleted between game versions do not linger.
            deleteRecursive(gameDir);
            if (!gameDir.mkdirs() && !gameDir.isDirectory()) {
                throw new IOException("Cannot create " + gameDir);
            }

            long free = new StatFs(gameDir.getAbsolutePath()).getAvailableBytes();
            long needed = totalBytes + 64L * 1024 * 1024;
            if (totalBytes > 0 && free < needed) {
                fail(String.format(java.util.Locale.US,
                    "Not enough free storage.\n\nThe game needs %d MB, but only %d MB are free.\nFree up some space and open the game again.",
                    needed / (1024 * 1024), free / (1024 * 1024)));
                return;
            }

            String canonicalRoot = gameDir.getCanonicalPath() + File.separator;
            byte[] buf = new byte[256 * 1024];
            long done = 0;
            int lastPermille = -1;

            try (ZipInputStream zin = new ZipInputStream(new BufferedInputStream(getAssets().open(GAME_ASSET), 1 << 20))) {
                ZipEntry entry;
                while ((entry = zin.getNextEntry()) != null) {
                    if (mCancelled) return;

                    File out = new File(gameDir, entry.getName());
                    // Guard against path traversal in entry names
                    if (!out.getCanonicalPath().startsWith(canonicalRoot)) {
                        throw new IOException("Bad entry in game archive: " + entry.getName());
                    }

                    if (entry.isDirectory()) {
                        out.mkdirs();
                        continue;
                    }

                    File parent = out.getParentFile();
                    if (parent != null && !parent.isDirectory() && !parent.mkdirs()) {
                        throw new IOException("Cannot create " + parent);
                    }

                    try (OutputStream os = new BufferedOutputStream(new FileOutputStream(out), 1 << 18)) {
                        int n;
                        while ((n = zin.read(buf)) > 0) {
                            os.write(buf, 0, n);
                            done += n;
                        }
                    }

                    if (totalBytes > 0) {
                        int permille = (int) Math.min(1000, done * 1000 / totalBytes);
                        if (permille != lastPermille) {
                            lastPermille = permille;
                            setStatus(String.format(java.util.Locale.US,
                                "Preparing game files (first launch only)...\n%d%%", permille / 10), permille);
                        }
                    }
                }
            }

            if (!new File(gameDir, MARKER_FILE).createNewFile() && !new File(gameDir, MARKER_FILE).isFile()) {
                throw new IOException("Cannot write install marker");
            }
            getSharedPreferences(PREFS, MODE_PRIVATE).edit().putString("stamp", stamp).commit();
            Log.i(TAG, "Game installed to " + gameDir + " (" + done + " bytes)");

            runOnUiThread(this::launchGame);
        } catch (Throwable e) {
            Log.e(TAG, "Game install failed", e);
            deleteRecursive(new File(gameDir, MARKER_FILE));
            fail("Could not prepare the game files:\n\n" + e.getMessage()
                + "\n\nMake sure there is enough free storage and try again.");
        }
    }

    private void fail(final String message)
    {
        runOnUiThread(() -> {
            if (isFinishing()) return;
            new AlertDialog.Builder(this)
                .setTitle("Time Wardens")
                .setMessage(message)
                .setCancelable(false)
                .setPositiveButton("Close", (d, w) -> finish())
                .show();
        });
    }

    private void launchGame()
    {
        Intent intent = new Intent(this, MainActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
        startActivity(intent);
        finish();
    }

    private static void deleteRecursive(File f)
    {
        if (f == null || !f.exists()) return;
        if (f.isDirectory()) {
            File[] children = f.listFiles();
            if (children != null) {
                for (File c : children) deleteRecursive(c);
            }
        }
        if (!f.delete()) {
            Log.w(TAG, "Could not delete " + f);
        }
    }
}
