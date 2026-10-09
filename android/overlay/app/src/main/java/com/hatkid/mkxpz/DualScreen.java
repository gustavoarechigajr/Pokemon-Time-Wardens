package com.hatkid.mkxpz;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Presentation;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ClipDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.LayerDrawable;
import android.hardware.display.DisplayManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.util.LruCache;
import android.util.TypedValue;
import android.view.Display;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONObject;
import org.libsdl.app.SDLActivity;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Locale;

/**
 * Dual-screen support (e.g. AYN Thor): while the game runs on the main
 * screen, a second display shows a live info panel (party, location, money,
 * play time, badges) plus touch shortcut buttons.
 *
 * Data comes from the game: Mods/Android_DualScreen.rb writes
 * .tw_status.json in the game folder while the ".tw_dualscreen" flag file
 * exists. The panel can be switched off from the panel itself; the choice is
 * remembered.
 */
public class DualScreen implements DisplayManager.DisplayListener
{
    private static final String TAG = "TimeWardens[Dual]";
    private static final String PREFS = "dualscreen";

    private final Activity mActivity;
    private final File mGameDir;
    private final File mFlag;
    private final File mStatusFile;
    private final DisplayManager mDisplayManager;
    private final Handler mHandler = new Handler(Looper.getMainLooper());

    private StatusPresentation mPresentation;
    private boolean mStarted = false;

    public DualScreen(Activity activity, File gameDir)
    {
        mActivity = activity;
        mGameDir = gameDir;
        mFlag = new File(gameDir, ".tw_dualscreen");
        mStatusFile = new File(gameDir, ".tw_status.json");
        mDisplayManager = (DisplayManager) activity.getSystemService(Context.DISPLAY_SERVICE);
    }

    public void onStart()
    {
        mStarted = true;
        mDisplayManager.registerDisplayListener(this, mHandler);
        update();
    }

    public void onStop()
    {
        mStarted = false;
        mDisplayManager.unregisterDisplayListener(this);
        dismiss();
    }

    /** Picks the second screen, if the device has one. */
    private Display findSecondDisplay()
    {
        Display[] displays = mDisplayManager.getDisplays(DisplayManager.DISPLAY_CATEGORY_PRESENTATION);
        for (Display d : displays) {
            if (d.getDisplayId() != Display.DEFAULT_DISPLAY && d.isValid()) return d;
        }
        // Some devices don't flag their built-in second screen as a
        // presentation display; fall back to any other valid display.
        for (Display d : mDisplayManager.getDisplays()) {
            if (d.getDisplayId() != Display.DEFAULT_DISPLAY && d.isValid()
                && (d.getFlags() & Display.FLAG_PRIVATE) == 0) return d;
        }
        return null;
    }

    private void update()
    {
        if (!mStarted) return;
        Display display = findSecondDisplay();

        if (mPresentation != null && (display == null || mPresentation.getDisplay().getDisplayId() != display.getDisplayId())) {
            dismiss();
        }

        if (display != null && mPresentation == null) {
            Log.i(TAG, "Second screen found: " + display.getName() + " (id " + display.getDisplayId() + ")");
            try {
                mPresentation = new StatusPresentation(mActivity, display);
                mPresentation.setOnDismissListener(d -> {
                    if (mPresentation == d) mPresentation = null;
                    setFlag(false);
                });
                mPresentation.show();
                setFlag(true);
            } catch (WindowManager.InvalidDisplayException e) {
                Log.w(TAG, "Could not show panel on second screen", e);
                mPresentation = null;
            }
        }
    }

    private void dismiss()
    {
        if (mPresentation != null) {
            mPresentation.dismiss();
            mPresentation = null;
        }
        setFlag(false);
    }

    private void setFlag(boolean on)
    {
        try {
            if (on) {
                if (!mFlag.exists()) mFlag.createNewFile();
            } else {
                mFlag.delete();
            }
        } catch (IOException e) {
            Log.w(TAG, "Flag file: " + e);
        }
    }

    @Override public void onDisplayAdded(int displayId) { update(); }
    @Override public void onDisplayRemoved(int displayId) { update(); }
    @Override public void onDisplayChanged(int displayId) { update(); }

    // -------------------------------------------------------------------------

    private class StatusPresentation extends Presentation
    {
        private final SharedPreferences mPrefs;
        private final LruCache<String, Bitmap> mIcons = new LruCache<>(24);

        private FrameLayout mRoot;
        private View mPanel;
        private TextView mOffHint;
        private TextView mHeader, mLocation, mMoney, mTime, mBadges, mWaiting;
        private LinearLayout mPartyList;
        private long mLastModified = -1;

        private final Runnable mPoll = new Runnable() {
            @Override public void run() {
                refresh();
                mHandler.postDelayed(this, 500);
            }
        };

        StatusPresentation(Context ctx, Display display)
        {
            super(ctx, display);
            mPrefs = ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
        }

        private int dp(float v)
        {
            return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, v, getContext().getResources().getDisplayMetrics());
        }

        @Override
        protected void onCreate(Bundle savedInstanceState)
        {
            super.onCreate(savedInstanceState);
            // Never take input focus: controller buttons must keep going to
            // the game on the main screen. Touches still work.
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
                | WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
            getWindow().setBackgroundDrawable(new ColorDrawable(Color.BLACK));

            mRoot = new FrameLayout(getContext());
            mRoot.setBackgroundColor(Color.BLACK);
            mPanel = buildPanel();
            mRoot.addView(mPanel);

            mOffHint = new TextView(getContext());
            mOffHint.setText("Info panel off - tap to turn on");
            mOffHint.setTextColor(Color.rgb(0x40, 0x40, 0x48));
            mOffHint.setGravity(Gravity.CENTER);
            mOffHint.setOnClickListener(v -> setPanelOn(true));
            mRoot.addView(mOffHint, new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));

            setContentView(mRoot);
            setPanelOn(mPrefs.getBoolean("panel_on", true));
        }

        @Override
        protected void onStart()
        {
            super.onStart();
            mHandler.post(mPoll);
        }

        @Override
        protected void onStop()
        {
            mHandler.removeCallbacks(mPoll);
            super.onStop();
        }

        private void setPanelOn(boolean on)
        {
            mPrefs.edit().putBoolean("panel_on", on).apply();
            mPanel.setVisibility(on ? View.VISIBLE : View.GONE);
            mOffHint.setVisibility(on ? View.GONE : View.VISIBLE);
            mLastModified = -1;
            Log.i(TAG, "Info panel " + (on ? "on" : "off"));
        }

        private TextView text(float sp, int color, boolean bold)
        {
            TextView t = new TextView(getContext());
            t.setTextSize(TypedValue.COMPLEX_UNIT_SP, sp);
            t.setTextColor(color);
            t.setSingleLine(true);
            if (bold) t.setTypeface(Typeface.DEFAULT_BOLD);
            return t;
        }

        private View buildPanel()
        {
            int pad = dp(10);
            LinearLayout col = new LinearLayout(getContext());
            col.setOrientation(LinearLayout.VERTICAL);
            col.setPadding(pad, pad, pad, pad);
            col.setBackgroundColor(Color.rgb(0x18, 0x18, 0x22));

            // Top: party (left) and trainer info (right)
            LinearLayout top = new LinearLayout(getContext());
            top.setOrientation(LinearLayout.HORIZONTAL);
            col.addView(top, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 0, 1f));

            mPartyList = new LinearLayout(getContext());
            mPartyList.setOrientation(LinearLayout.VERTICAL);
            top.addView(mPartyList, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.MATCH_PARENT, 1.6f));

            LinearLayout info = new LinearLayout(getContext());
            info.setOrientation(LinearLayout.VERTICAL);
            info.setPadding(pad, 0, 0, 0);
            top.addView(info, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.MATCH_PARENT, 1f));

            mHeader = text(18, Color.WHITE, true);
            mHeader.setText("Time Wardens");
            info.addView(mHeader);
            mLocation = text(15, Color.rgb(0xff, 0xd8, 0x70), true);
            info.addView(mLocation);
            mMoney = text(14, Color.LTGRAY, false);
            info.addView(mMoney);
            mBadges = text(14, Color.LTGRAY, false);
            info.addView(mBadges);
            mTime = text(14, Color.LTGRAY, false);
            info.addView(mTime);
            mWaiting = text(13, Color.GRAY, false);
            mWaiting.setSingleLine(false);
            mWaiting.setText("Start or load a game to see your party here.");
            info.addView(mWaiting);

            // Bottom: shortcut buttons (send the same keys as the game's controls)
            LinearLayout buttons = new LinearLayout(getContext());
            buttons.setOrientation(LinearLayout.HORIZONTAL);
            buttons.setPadding(0, pad, 0, 0);
            col.addView(buttons, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(52)));
            addKeyButton(buttons, "Menu", KeyEvent.KEYCODE_X);
            addKeyButton(buttons, "Action", KeyEvent.KEYCODE_Z);
            addKeyButton(buttons, "Special", KeyEvent.KEYCODE_D);
            addKeyButton(buttons, "Speed +", KeyEvent.KEYCODE_Q);
            addKeyButton(buttons, "Speed -", KeyEvent.KEYCODE_W);
            TextView off = makeButton("Panel off");
            off.setOnClickListener(v -> setPanelOn(false));
            buttons.addView(off, buttonParams());

            return col;
        }

        private LinearLayout.LayoutParams buttonParams()
        {
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.MATCH_PARENT, 1f);
            lp.setMargins(dp(3), 0, dp(3), 0);
            return lp;
        }

        private TextView makeButton(String label)
        {
            TextView b = text(14, Color.WHITE, true);
            b.setText(label);
            b.setGravity(Gravity.CENTER);
            GradientDrawable bg = new GradientDrawable();
            bg.setColor(Color.rgb(0x33, 0x33, 0x44));
            bg.setCornerRadius(dp(10));
            b.setBackground(bg);
            return b;
        }

        @SuppressLint("ClickableViewAccessibility")
        private void addKeyButton(LinearLayout parent, String label, final int keycode)
        {
            final TextView b = makeButton(label);
            b.setOnTouchListener((v, e) -> {
                switch (e.getActionMasked()) {
                    case MotionEvent.ACTION_DOWN:
                        v.setAlpha(0.6f);
                        SDLActivity.onNativeKeyDown(keycode);
                        return true;
                    case MotionEvent.ACTION_UP:
                    case MotionEvent.ACTION_CANCEL:
                        v.setAlpha(1f);
                        SDLActivity.onNativeKeyUp(keycode);
                        return true;
                }
                return true;
            });
            parent.addView(b, buttonParams());
        }

        private void refresh()
        {
            if (mPanel == null || mPanel.getVisibility() != View.VISIBLE) return;
            long mod = mStatusFile.lastModified();
            if (mod == 0 || mod == mLastModified) return;
            mLastModified = mod;
            try {
                show(new JSONObject(readFile(mStatusFile)));
            } catch (Exception e) {
                Log.w(TAG, "Bad status file: " + e);
            }
        }

        private String readFile(File f) throws IOException
        {
            try (FileInputStream in = new FileInputStream(f)) {
                byte[] data = new byte[(int) Math.min(f.length(), 1 << 20)];
                int n = 0, r;
                while (n < data.length && (r = in.read(data, n, data.length - n)) > 0) n += r;
                return new String(data, 0, n, StandardCharsets.UTF_8);
            }
        }

        private void show(JSONObject s)
        {
            boolean ingame = s.optBoolean("ingame", false);
            mWaiting.setVisibility(ingame ? View.GONE : View.VISIBLE);
            if (!ingame) {
                mHeader.setText("Time Wardens");
                mLocation.setText("");
                mMoney.setText("");
                mBadges.setText("");
                mTime.setText("");
                mPartyList.removeAllViews();
                return;
            }
            mHeader.setText(s.optString("player", "Trainer"));
            mLocation.setText(s.optString("map", ""));
            mMoney.setText(String.format(Locale.US, "Money: $%,d", s.optLong("money", 0)));
            mBadges.setText("Badges: " + s.optInt("badges", 0));
            long t = s.optLong("time", 0);
            mTime.setText(String.format(Locale.US, "Play time: %d:%02d", t / 3600, (t / 60) % 60));

            mPartyList.removeAllViews();
            JSONArray party = s.optJSONArray("party");
            if (party == null) return;
            for (int i = 0; i < party.length() && i < 6; i++) {
                JSONObject p = party.optJSONObject(i);
                if (p != null) mPartyList.addView(partyRow(p), new LinearLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT, 0, 1f));
            }
            for (int i = party.length(); i < 6; i++) {
                mPartyList.addView(new View(getContext()), new LinearLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT, 0, 1f));
            }
        }

        private View partyRow(JSONObject p)
        {
            LinearLayout row = new LinearLayout(getContext());
            row.setOrientation(LinearLayout.HORIZONTAL);
            row.setGravity(Gravity.CENTER_VERTICAL);

            ImageView icon = new ImageView(getContext());
            icon.setScaleType(ImageView.ScaleType.FIT_CENTER);
            Bitmap bmp = loadIcon(p.optString("icon", ""));
            if (bmp != null) icon.setImageBitmap(bmp);
            row.addView(icon, new LinearLayout.LayoutParams(dp(44), dp(44)));

            LinearLayout texts = new LinearLayout(getContext());
            texts.setOrientation(LinearLayout.VERTICAL);
            texts.setPadding(dp(6), 0, 0, 0);
            row.addView(texts, new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));

            boolean egg = p.optBoolean("egg", false);
            String status = p.optString("status", "NONE");
            TextView name = text(14, p.optBoolean("shiny", false) ? Color.rgb(0xff, 0xe0, 0x60) : Color.WHITE, true);
            String line = p.optString("name", "?");
            if (!egg) line += "  Lv." + p.optInt("lv", 0);
            if (!egg && !"NONE".equals(status)) line += "  " + statusLabel(status);
            name.setText(line);
            texts.addView(name);

            if (!egg) {
                int hp = p.optInt("hp", 0), max = Math.max(1, p.optInt("maxhp", 1));
                LinearLayout hpRow = new LinearLayout(getContext());
                hpRow.setOrientation(LinearLayout.HORIZONTAL);
                hpRow.setGravity(Gravity.CENTER_VERTICAL);
                ProgressBar bar = new ProgressBar(getContext(), null, android.R.attr.progressBarStyleHorizontal);
                bar.setMax(max);
                bar.setProgress(hp);
                bar.setProgressDrawable(hpDrawable(hp, max));
                hpRow.addView(bar, new LinearLayout.LayoutParams(0, dp(8), 1f));
                TextView hpText = text(12, Color.LTGRAY, false);
                hpText.setText(String.format(Locale.US, "  %d/%d", hp, max));
                hpRow.addView(hpText);
                texts.addView(hpRow);
            }
            return row;
        }

        private String statusLabel(String s)
        {
            switch (s) {
                case "POISON": return "PSN";
                case "BURN": return "BRN";
                case "PARALYSIS": return "PAR";
                case "SLEEP": return "SLP";
                case "FROZEN": return "FRZ";
                case "DROWSY": return "DRW";
                case "FROSTBITE": return "FRB";
                default: return s.length() > 3 ? s.substring(0, 3) : s;
            }
        }

        private LayerDrawable hpDrawable(int hp, int max)
        {
            int color = hp * 2 > max ? Color.rgb(0x40, 0xd0, 0x60)
                : hp * 5 > max ? Color.rgb(0xf0, 0xc0, 0x30) : Color.rgb(0xe0, 0x40, 0x40);
            if (hp <= 0) color = Color.DKGRAY;
            GradientDrawable back = new GradientDrawable();
            back.setColor(Color.rgb(0x30, 0x30, 0x3a));
            back.setCornerRadius(dp(4));
            GradientDrawable front = new GradientDrawable();
            front.setColor(color);
            front.setCornerRadius(dp(4));
            LayerDrawable ld = new LayerDrawable(new android.graphics.drawable.Drawable[] {
                back, new ClipDrawable(front, Gravity.START, ClipDrawable.HORIZONTAL) });
            ld.setId(0, android.R.id.background);
            ld.setId(1, android.R.id.progress);
            return ld;
        }

        /** Loads the first frame of an Essentials party icon (2-frame sheet). */
        private Bitmap loadIcon(String path)
        {
            if (path.isEmpty()) return null;
            Bitmap cached = mIcons.get(path);
            if (cached != null) return cached;
            File f = resolve(path);
            if (f == null) return null;
            Bitmap full = BitmapFactory.decodeFile(f.getAbsolutePath());
            if (full == null) return null;
            Bitmap frame = full;
            if (full.getWidth() >= full.getHeight() * 2) {
                frame = Bitmap.createBitmap(full, 0, 0, full.getHeight(), full.getHeight());
            }
            mIcons.put(path, frame);
            return frame;
        }

        /** Game-relative path (with or without .png) to a file, ignoring case. */
        private File resolve(String rel)
        {
            String[] candidates = rel.toLowerCase(Locale.ROOT).endsWith(".png")
                ? new String[] { rel } : new String[] { rel + ".png", rel };
            for (String c : candidates) {
                File f = new File(mGameDir, c);
                if (f.isFile()) return f;
                File parent = f.getParentFile();
                String[] names = parent != null ? parent.list() : null;
                if (names != null) {
                    for (String n : names) {
                        if (n.equalsIgnoreCase(f.getName())) return new File(parent, n);
                    }
                }
            }
            return null;
        }
    }
}
