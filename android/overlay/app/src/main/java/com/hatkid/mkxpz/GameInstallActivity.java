package com.hatkid.mkxpz;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageInstaller;
import android.graphics.Color;
import android.os.Bundle;
import android.os.StatFs;
import android.util.Log;
import android.util.TypedValue;
import android.view.Gravity;
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
import java.util.Locale;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

/**
 * Launcher activity: makes sure the game files are installed and up to date,
 * then starts MainActivity (the mkxp-z engine).
 *
 * - The full APK bundles the game as assets/game.zip. It is unpacked into the
 *   app's external files directory when this APK carries a newer game build
 *   than the one installed (first launch, or after installing a newer full
 *   APK). Essentials loads scripts with plain Ruby file I/O, so the files must
 *   exist on a real filesystem.
 * - On every launch it asks the GitHub release (see Updater) whether a newer
 *   game build or app version exists, and offers to download just the changed
 *   files or the small update APK.
 *
 * Saves are not stored here: mkxp-z keeps them in the internal data
 * directory (System.data_directory), so updates never touch them.
 */
public class GameInstallActivity extends Activity
{
    private static final String TAG = "TimeWardens[Install]";
    static final String ACTION_INSTALL_STATUS = "com.hatkid.mkxpz.INSTALL_STATUS";
    private static final String GAME_ASSET = "game.zip";
    private static final String GAME_INFO_ASSET = "game.properties";
    private static final String MANIFEST_ASSET = "game-manifest.json.gz";
    private static final String MARKER_FILE = ".installed";
    private static final String PREFS = "install";

    private ProgressBar mProgress;
    private TextView mStatus;
    private volatile boolean mCancelled = false;
    private SharedPreferences mPrefs;
    private Updater mUpdater;

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

    private Properties readAssetProps(String name)
    {
        Properties p = new Properties();
        try (InputStream in = getAssets().open(name)) {
            p.load(in);
        } catch (IOException e) {
            // not bundled
        }
        return p;
    }

    private boolean hasAsset(String name)
    {
        try (InputStream in = getAssets().open(name)) {
            return true;
        } catch (IOException e) {
            return false;
        }
    }

    /** Game build currently on disk, or -1 if no complete game is installed. */
    private int installedBuild(File gameDir)
    {
        if (!new File(gameDir, MARKER_FILE).isFile() || !new File(gameDir, "Game.ini").isFile()) return -1;
        return mPrefs.getInt("game_build", 0);
    }

    private int myVersionCode()
    {
        try {
            PackageInfo info = getPackageManager().getPackageInfo(getPackageName(), 0);
            return info.versionCode;
        } catch (Exception e) {
            return 0;
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        mPrefs = getSharedPreferences(PREFS, MODE_PRIVATE);
        mUpdater = new Updater(this);

        if (ACTION_INSTALL_STATUS.equals(getIntent().getAction())) {
            handleInstallStatus(getIntent());
            return;
        }

        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        buildUi();
        final File gameDir = getGameDir(this);
        new Thread(() -> startup(gameDir), "game-startup").start();
    }

    @Override
    protected void onNewIntent(Intent intent)
    {
        super.onNewIntent(intent);
        if (ACTION_INSTALL_STATUS.equals(intent.getAction())) handleInstallStatus(intent);
    }

    @Override
    protected void onDestroy()
    {
        mCancelled = true;
        super.onDestroy();
    }

    // ------------------------------------------------------------------ flow

    private void startup(File gameDir)
    {
        try {
            int installed = installedBuild(gameDir);
            boolean bundled = hasAsset(GAME_ASSET);
            int bundledBuild = bundled ? Integer.parseInt(readAssetProps(GAME_INFO_ASSET).getProperty("build", "0")) : -1;

            // 1. Unpack the game bundled in this APK if it is newer
            if (bundled && (installed < 0 || bundledBuild > installed)) {
                if (!extractBundled(gameDir, bundledBuild)) return;
                installed = bundledBuild;
            }

            // 2. Ask the release for newer builds
            setStatus(installed < 0 ? "Connecting to download the game..." : "Checking for updates...", -1);
            Updater.Info info = mUpdater.check();

            if (installed < 0) {
                // Update APK installed on its own: the game has to be downloaded
                if (info == null) {
                    fail("The game files are not installed yet and could not be downloaded.\n\n"
                        + "Connect to the internet and open the game again, or install the full APK.", false);
                    return;
                }
                runGameUpdate(gameDir, info, true);
                return;
            }

            if (info != null) {
                boolean appUpdate = !info.engineId.isEmpty() && !info.engineId.equals(mUpdater.engineId())
                    && info.apkVersionCode > myVersionCode();
                boolean gameUpdate = info.build > installed;
                if (appUpdate || gameUpdate) {
                    offerUpdates(gameDir, info, appUpdate, gameUpdate);
                    return;
                }
            }
            runOnUiThread(this::launchGame);
        } catch (Throwable e) {
            Log.e(TAG, "Startup failed", e);
            fail("Could not prepare the game files:\n\n" + e.getMessage()
                + "\n\nMake sure there is enough free storage and try again.", false);
        }
    }

    private void offerUpdates(final File gameDir, final Updater.Info info, final boolean appUpdate, final boolean gameUpdate)
    {
        // Size the game update before asking
        Updater.Plan plan = null;
        if (gameUpdate) {
            try {
                plan = mUpdater.plan(gameDir, info.build);
            } catch (Exception e) {
                Log.w(TAG, "Could not plan game update", e);
            }
        }
        final Updater.Plan finalPlan = plan;
        if (finalPlan != null && finalPlan.isEmpty() && !appUpdate) {
            // Newer build, but no game file changed
            mPrefs.edit().putInt("game_build", info.build).commit();
            runOnUiThread(this::launchGame);
            return;
        }

        StringBuilder msg = new StringBuilder();
        if (finalPlan != null && !finalPlan.isEmpty()) {
            msg.append(String.format(Locale.US, "Game update (build %d): %d file%s, %s.",
                info.build, finalPlan.fileCount(), finalPlan.fileCount() == 1 ? "" : "s", mb(finalPlan.bytes())));
        }
        if (appUpdate) {
            if (msg.length() > 0) msg.append("\n\n");
            msg.append(String.format(Locale.US, "App update: %s download. Android will ask you to confirm the install; "
                + "your saves and game files are kept.", mb(info.updateApkBytes)));
        }
        if (msg.length() == 0) {
            runOnUiThread(this::launchGame);
            return;
        }

        runOnUiThread(() -> {
            if (isFinishing()) return;
            new AlertDialog.Builder(this)
                .setTitle("Update available")
                .setMessage(msg.toString())
                .setCancelable(false)
                .setPositiveButton("Update now", (d, w) -> new Thread(() -> {
                    if (finalPlan != null && !finalPlan.isEmpty()) {
                        if (!applyPlan(gameDir, finalPlan)) return;
                    } else if (gameUpdate) {
                        mPrefs.edit().putInt("game_build", info.build).commit();
                    }
                    if (appUpdate) {
                        runAppUpdate(info);
                    } else {
                        runOnUiThread(this::launchGame);
                    }
                }, "update").start())
                .setNegativeButton("Later", (d, w) -> launchGame())
                .show();
        });
    }

    private void runGameUpdate(File gameDir, Updater.Info info, boolean firstInstall)
    {
        try {
            setStatus("Preparing download...", -1);
            Updater.Plan plan = mUpdater.plan(gameDir, info.build);
            if (firstInstall) {
                long free = new StatFs(gameDir.getParentFile() != null && gameDir.getParentFile().exists()
                    ? gameDir.getParentFile().getAbsolutePath() : getFilesDir().getAbsolutePath()).getAvailableBytes();
                if (free < plan.bytes() * 2) {
                    fail(String.format(Locale.US, "Not enough free storage to download the game (%s needed).", mb(plan.bytes() * 2)), false);
                    return;
                }
            }
            if (applyPlan(gameDir, plan)) runOnUiThread(this::launchGame);
        } catch (Exception e) {
            Log.e(TAG, "Download failed", e);
            fail("The game download failed:\n\n" + e.getMessage() + "\n\nCheck your connection and open the game again.", false);
        }
    }

    /** Downloads the planned files; returns false (after showing an error) on failure. */
    private boolean applyPlan(File gameDir, Updater.Plan plan)
    {
        try {
            gameDir.mkdirs();
            mUpdater.apply(gameDir, plan, (message, done, total) ->
                setStatus(message + String.format(Locale.US, "\n%s / %s", mb(done), mb(total)),
                    (int) Math.min(1000, done * 1000 / Math.max(1, total))));
            new File(gameDir, MARKER_FILE).createNewFile();
            mPrefs.edit().putInt("game_build", plan.build).commit();
            return true;
        } catch (Exception e) {
            Log.e(TAG, "Game update failed", e);
            fail("The update could not be downloaded:\n\n" + e.getMessage()
                + "\n\nYou can try again next time you open the game.", true);
            return false;
        }
    }

    private void runAppUpdate(Updater.Info info)
    {
        try {
            mUpdater.installAppUpdate(info, (message, done, total) ->
                setStatus(message + String.format(Locale.US, "\n%s / %s", mb(done), mb(total)),
                    (int) Math.min(1000, done * 1000 / Math.max(1, total))));
            setStatus("Waiting for Android to install the update...", -1);
        } catch (Exception e) {
            Log.e(TAG, "App update failed", e);
            fail("The app update could not be downloaded:\n\n" + e.getMessage(), true);
        }
    }

    private void handleInstallStatus(Intent intent)
    {
        int status = intent.getIntExtra(PackageInstaller.EXTRA_STATUS, PackageInstaller.STATUS_FAILURE);
        if (status == PackageInstaller.STATUS_PENDING_USER_ACTION) {
            Intent confirm = intent.getParcelableExtra(Intent.EXTRA_INTENT);
            if (confirm != null) {
                confirm.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(confirm);
            }
            finish();
        } else if (status == PackageInstaller.STATUS_SUCCESS) {
            finish();
        } else {
            String why = intent.getStringExtra(PackageInstaller.EXTRA_STATUS_MESSAGE);
            Log.w(TAG, "App update not installed: " + status + " " + why);
            buildUi();
            fail("The app update was not installed" + (why != null ? ":\n\n" + why : ".")
                + "\n\nIf Android blocked it, allow \"Install unknown apps\" for Time Wardens and try again.", true);
        }
    }

    // --------------------------------------------------------------- extract

    /** Unpacks assets/game.zip; returns false (after showing an error) on failure. */
    private boolean extractBundled(File gameDir, int build) throws IOException
    {
        Properties info = readAssetProps(GAME_INFO_ASSET);
        long totalBytes = Long.parseLong(info.getProperty("uncompressed_bytes", "0"));

        // Remove any previous copy so files deleted between versions don't linger
        deleteRecursive(gameDir);
        if (!gameDir.mkdirs() && !gameDir.isDirectory()) {
            throw new IOException("Cannot create " + gameDir);
        }

        long free = new StatFs(gameDir.getAbsolutePath()).getAvailableBytes();
        long needed = totalBytes + 64L * 1024 * 1024;
        if (totalBytes > 0 && free < needed) {
            fail(String.format(Locale.US,
                "Not enough free storage.\n\nThe game needs %d MB, but only %d MB are free.\nFree up some space and open the game again.",
                needed / (1024 * 1024), free / (1024 * 1024)), false);
            return false;
        }

        String canonicalRoot = gameDir.getCanonicalPath() + File.separator;
        byte[] buf = new byte[256 * 1024];
        long done = 0;
        int lastPermille = -1;

        try (ZipInputStream zin = new ZipInputStream(new BufferedInputStream(getAssets().open(GAME_ASSET), 1 << 20))) {
            ZipEntry entry;
            while ((entry = zin.getNextEntry()) != null) {
                if (mCancelled) return false;

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
                        setStatus(String.format(Locale.US,
                            "Preparing game files...\n%d%%", permille / 10), permille);
                    }
                }
            }
        }

        // Remember exactly which files are installed (used by the updater)
        try (InputStream in = getAssets().open(MANIFEST_ASSET);
             OutputStream os = new FileOutputStream(new File(gameDir, Updater.MANIFEST_NAME))) {
            int n;
            while ((n = in.read(buf)) > 0) os.write(buf, 0, n);
        } catch (IOException e) {
            Log.w(TAG, "No bundled manifest: " + e);
        }

        if (!new File(gameDir, MARKER_FILE).createNewFile() && !new File(gameDir, MARKER_FILE).isFile()) {
            throw new IOException("Cannot write install marker");
        }
        mPrefs.edit().putInt("game_build", build).commit();
        Log.i(TAG, "Game installed to " + gameDir + " (" + done + " bytes, build " + build + ")");
        return true;
    }

    // -------------------------------------------------------------------- ui

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
        mStatus.setText("Starting...");
        mStatus.setTextColor(Color.LTGRAY);
        mStatus.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16);
        mStatus.setGravity(Gravity.CENTER);
        mStatus.setPadding(0, dp(16), 0, dp(16));
        root.addView(mStatus);

        mProgress = new ProgressBar(this, null, android.R.attr.progressBarStyleHorizontal);
        mProgress.setMax(1000);
        mProgress.setIndeterminate(true);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(dp(360), LinearLayout.LayoutParams.WRAP_CONTENT);
        root.addView(mProgress, lp);

        setContentView(root);
    }

    private int dp(int v)
    {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, v, getResources().getDisplayMetrics());
    }

    private static String mb(long bytes)
    {
        if (bytes < 1024 * 1024) return String.format(Locale.US, "%d KB", Math.max(1, bytes / 1024));
        return String.format(Locale.US, "%.1f MB", bytes / (1024.0 * 1024.0));
    }

    /** Updates the status text; permille < 0 shows an indeterminate bar. */
    private void setStatus(final String text, final int permille)
    {
        runOnUiThread(() -> {
            if (mStatus != null) mStatus.setText(text);
            if (mProgress != null) {
                mProgress.setIndeterminate(permille < 0);
                if (permille >= 0) mProgress.setProgress(permille);
            }
        });
    }

    /** Shows an error; with canPlay the player may continue with the installed game. */
    private void fail(final String message, final boolean canPlay)
    {
        runOnUiThread(() -> {
            if (isFinishing()) return;
            AlertDialog.Builder b = new AlertDialog.Builder(this)
                .setTitle("Time Wardens")
                .setMessage(message)
                .setCancelable(false);
            if (canPlay && installedBuild(getGameDir(this)) >= 0) {
                b.setPositiveButton("Play", (d, w) -> launchGame());
                b.setNegativeButton("Close", (d, w) -> finish());
            } else {
                b.setPositiveButton("Close", (d, w) -> finish());
            }
            b.show();
        });
    }

    private void launchGame()
    {
        if (isFinishing()) return;
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
