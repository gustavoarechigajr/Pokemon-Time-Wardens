package com.hatkid.mkxpz;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Presentation;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.hardware.display.DisplayManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.util.Log;
import android.view.Display;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;

import org.json.JSONArray;
import org.json.JSONObject;
import org.libsdl.app.SDLActivity;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Dual-screen support (e.g. AYN Thor): while the game runs on the main
 * screen, the second display becomes a second game screen drawn with the
 * game's own graphics and fonts:
 *
 *   PARTY   - live copy of the in-game party screen (animated icons, HP bars
 *             that drain/fill, status, shiny, held item, Poke Ball)
 *   JOURNAL - BW-style location sign, current story objective, trainer info,
 *             in-game clock and the chapters earned so far
 *
 * plus touch buttons along the bottom (page tabs, Menu, game speed) and a
 * "screen off" button. The game feeds it through Mods/Android_DualScreen.rb,
 * which writes .tw_status.json while the ".tw_dualscreen" flag file exists.
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

    private SecondScreen mPresentation;
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
        for (Display d : mDisplayManager.getDisplays(DisplayManager.DISPLAY_CATEGORY_PRESENTATION)) {
            if (d.getDisplayId() != Display.DEFAULT_DISPLAY && d.isValid()) return d;
        }
        // Some devices don't flag their built-in second screen as a
        // presentation display; fall back to any other public display.
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
                final SecondScreen p = new SecondScreen(mActivity, display);
                p.setOnDismissListener(d -> {
                    if (mPresentation == p) mPresentation = null;
                    setFlag(false);
                });
                mPresentation = p;
                p.show();
                setFlag(true);
            } catch (WindowManager.InvalidDisplayException e) {
                Log.w(TAG, "Could not show the second screen", e);
                mPresentation = null;
            }
        }
    }

    private void dismiss()
    {
        if (mPresentation != null) {
            SecondScreen p = mPresentation;
            mPresentation = null;
            p.dismiss();
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

    // =========================================================================

    private class SecondScreen extends Presentation
    {
        SecondScreen(Context ctx, Display display)
        {
            super(ctx, display);
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
            setContentView(new PadView(getContext()));
        }
    }

    // =========================================================================

    /** Draws the pages on a 512x384 canvas (the game's resolution) and scales it up. */
    @SuppressLint("ViewConstructor")
    private class PadView extends View
    {
        static final int W = 512, H = 384;
        static final int PAGE_PARTY = 0, PAGE_JOURNAL = 1, PAGE_MAP = 2;
        static final int BTN_MENU = 3, BTN_SPEED = 4, BTN_SCREEN_OFF = 5, BTN_OBJECTIVE = 6;

        // Bottom buttons (the party screen's icon_cancel graphic, sliced to 96 wide)
        static final int BTN_Y = 330, BTN_W = 96, BTN_H = 48, BTN_STEP = 102, BTN_X0 = 4;
        final String[] BTN_LABELS = { "PARTY", "JOURNAL", "MAP", "MENU", "SPEED" };

        final SharedPreferences mPrefs;
        final Bitmap mCanvasBmp = Bitmap.createBitmap(W, H, Bitmap.Config.ARGB_8888);
        final Canvas mC = new Canvas(mCanvasBmp);
        final Paint mBlit = new Paint();          // nearest-neighbour, pixel art stays crisp
        final Paint mText = new Paint(Paint.ANTI_ALIAS_FLAG);
        final Paint mShape = new Paint(Paint.ANTI_ALIAS_FLAG);
        final Paint mDim = new Paint();
        final Map<String, Bitmap> mImages = new HashMap<>();
        final Typeface mFont, mSmallFont, mNarrowFont;
        final Rect mDst = new Rect();

        int mPage;
        boolean mScreenOn;
        int mPressed = -1;
        JSONObject mState;
        long mLastModified = -1;
        long mLastPoll = 0;
        // Objective text paging
        static final int LINES_PER_PAGE = 4;
        String mObjectiveText = null;
        List<String> mObjectiveLines = new ArrayList<>();
        int mObjectivePage = 0;
        long mObjectivePageAt = 0;

        void nextObjectivePage()
        {
            mObjectivePage++;
            mObjectivePageAt = SystemClock.uptimeMillis();
        }

        // Displayed HP per party slot, animated towards the real value
        final float[] mShownHp = new float[6];
        final String[] mShownName = new String[6];

        final Runnable mTick = new Runnable() {
            @Override public void run() {
                long now = SystemClock.uptimeMillis();
                if (now - mLastPoll >= 400) {
                    mLastPoll = now;
                    poll();
                }
                invalidate();
                mHandler.postDelayed(this, mScreenOn ? 50 : 500);
            }
        };

        PadView(Context ctx)
        {
            super(ctx);
            mPrefs = ctx.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
            mPage = Math.max(PAGE_PARTY, Math.min(PAGE_MAP, mPrefs.getInt("page", PAGE_PARTY)));
            mScreenOn = mPrefs.getBoolean("panel_on", true);
            mBlit.setFilterBitmap(false);
            mFont = font("Fonts/power green.ttf");
            mSmallFont = font("Fonts/power green small.ttf");
            mNarrowFont = font("Fonts/power green narrow.ttf");
            ColorMatrix cm = new ColorMatrix();
            cm.setScale(0.3f, 0.3f, 0.35f, 0.8f);
            mDim.setColorFilter(new ColorMatrixColorFilter(cm));
            mDim.setFilterBitmap(false);
        }

        private Typeface font(String rel)
        {
            File f = resolve(rel);
            try {
                if (f != null) return Typeface.createFromFile(f);
            } catch (RuntimeException e) {
                Log.w(TAG, "Font " + rel + ": " + e);
            }
            return Typeface.DEFAULT_BOLD;
        }

        @Override protected void onAttachedToWindow()
        {
            super.onAttachedToWindow();
            mHandler.post(mTick);
        }

        @Override protected void onDetachedFromWindow()
        {
            mHandler.removeCallbacks(mTick);
            super.onDetachedFromWindow();
        }

        // ---------------------------------------------------------------- data

        private void poll()
        {
            long mod = mStatusFile.lastModified();
            if (mod == 0 || mod == mLastModified) return;
            mLastModified = mod;
            try (FileInputStream in = new FileInputStream(mStatusFile)) {
                byte[] data = new byte[(int) Math.min(mStatusFile.length(), 1 << 20)];
                int n = 0, r;
                while (n < data.length && (r = in.read(data, n, data.length - n)) > 0) n += r;
                JSONObject prev = mState;
                mState = new JSONObject(new String(data, 0, n, StandardCharsets.UTF_8));
                boolean ingame = mState.optBoolean("ingame", false);
                if (prev == null || prev.optBoolean("ingame", false) != ingame) {
                    JSONArray party = mState.optJSONArray("party");
                    JSONObject loc = mState.optJSONObject("location");
                    Log.i(TAG, "Status: ingame=" + ingame
                        + " party=" + (party != null ? party.length() : 0)
                        + " location=" + (loc != null ? loc.optString("name") : "")
                        + " map=" + (mState.optJSONObject("map") != null));
                }
            } catch (Exception e) {
                Log.w(TAG, "Status file: " + e);
            }
        }

        /** Game-relative path (with or without .png) to a file, ignoring case. */
        private File resolve(String rel)
        {
            String[] candidates = rel.toLowerCase(Locale.ROOT).matches(".*\\.(png|ttf)$")
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

        private Bitmap image(String rel)
        {
            if (rel == null || rel.isEmpty()) return null;
            if (mImages.containsKey(rel)) return mImages.get(rel);
            Bitmap b = null;
            File f = resolve(rel);
            if (f != null) {
                BitmapFactory.Options o = new BitmapFactory.Options();
                o.inScaled = false;
                b = BitmapFactory.decodeFile(f.getAbsolutePath(), o);
            }
            if (mImages.size() > 96) mImages.clear();
            mImages.put(rel, b);
            return b;
        }

        // ------------------------------------------------------------- drawing

        private void blt(String rel, int x, int y)
        {
            Bitmap b = image(rel);
            if (b != null) mC.drawBitmap(b, x, y, mBlit);
        }

        private void blt(String rel, int x, int y, int sx, int sy, int sw, int sh, Paint p)
        {
            Bitmap b = image(rel);
            if (b == null || sw <= 0 || sh <= 0) return;
            mC.drawBitmap(b, new Rect(sx, sy, sx + sw, sy + sh), new Rect(x, y, x + sw, y + sh), p);
        }

        /** Like the game's pbDrawTextPositions: shadow at +2 offsets, y = top of text. */
        private void text(String s, float x, float y, Typeface tf, float size, int align, int base, int shadow)
        {
            if (s == null || s.isEmpty()) return;
            mText.setTypeface(tf);
            mText.setTextSize(size);
            float w = mText.measureText(s);
            if (align == 1) x -= w; else if (align == 2) x -= w / 2;
            float baseline = y - mText.ascent();
            mText.setColor(shadow);
            mC.drawText(s, x + 2, baseline, mText);
            mC.drawText(s, x, baseline + 2, mText);
            mC.drawText(s, x + 2, baseline + 2, mText);
            mText.setColor(base);
            mC.drawText(s, x, baseline, mText);
        }

        private void text(String s, float x, float y) { text(s, x, y, mFont, 27, 0, WHITE, SHADOW); }

        static final int WHITE = 0xfff8f8f8, SHADOW = 0xff282828;
        static final int GOLD = 0xfff8d060, GOLD_SHADOW = 0xff604010;
        static final int LILAC = 0xffc8c8e8;

        private void box(int x, int y, int w, int h)
        {
            RectF r = new RectF(x + 1, y + 1, x + w - 1, y + h - 1);
            mShape.setStyle(Paint.Style.FILL);
            mShape.setColor(0xdc1e1834);
            mC.drawRoundRect(r, 10, 10, mShape);
            mShape.setStyle(Paint.Style.STROKE);
            mShape.setStrokeWidth(2);
            mShape.setColor(WHITE);
            mC.drawRoundRect(r, 10, 10, mShape);
        }

        private List<String> wrap(String s, Typeface tf, float size, float width)
        {
            mText.setTypeface(tf);
            mText.setTextSize(size);
            List<String> out = new ArrayList<>();
            StringBuilder line = new StringBuilder();
            for (String word : s.split(" ")) {
                String t = line.length() == 0 ? word : line + " " + word;
                if (mText.measureText(t) <= width || line.length() == 0) {
                    line.setLength(0);
                    line.append(t);
                } else {
                    out.add(line.toString());
                    line.setLength(0);
                    line.append(word);
                }
            }
            if (line.length() > 0) out.add(line.toString());
            return out;
        }

        @Override
        protected void onDraw(Canvas canvas)
        {
            canvas.drawColor(Color.BLACK);
            if (!mScreenOn) {
                mText.setTypeface(mFont);
                mText.setTextSize(Math.max(18, getHeight() / 24f));
                mText.setColor(0xff303040);
                mText.setTextAlign(Paint.Align.CENTER);
                canvas.drawText("Tap to turn the second screen on", getWidth() / 2f, getHeight() / 2f, mText);
                mText.setTextAlign(Paint.Align.LEFT);
                return;
            }

            mC.drawColor(Color.BLACK);
            blt("Graphics/Pictures/Party/bg", 0, 0);
            boolean ingame = mState != null && mState.optBoolean("ingame", false);
            if (!ingame) {
                drawTitle();
            } else if (mPage == PAGE_JOURNAL) {
                drawJournal();
            } else if (mPage == PAGE_MAP) {
                drawMap();
            } else {
                drawParty();
            }
            drawButtons(ingame);

            // Scale the 512x384 page to fit, keeping its aspect ratio
            float scale = Math.min(getWidth() / (float) W, getHeight() / (float) H);
            int dw = (int) (W * scale), dh = (int) (H * scale);
            int dx = (getWidth() - dw) / 2, dy = (getHeight() - dh) / 2;
            mDst.set(dx, dy, dx + dw, dy + dh);
            canvas.drawBitmap(mCanvasBmp, null, mDst, mBlit);
        }

        private void drawTitle()
        {
            // The game's own title screen art until a save is loaded
            blt("Graphics/Titles/title", 0, 0);
        }

        /** Draws a party-screen button graphic stretched horizontally (end caps kept). */
        private void button(String rel, int x, int y, int w)
        {
            Bitmap b = image(rel);
            if (b == null) return;
            int h = b.getHeight(), e = 12;
            mC.drawBitmap(b, new Rect(0, 0, e, h), new Rect(x, y, x + e, y + h), mBlit);
            mC.drawBitmap(b, new Rect(e, 0, b.getWidth() - e, h), new Rect(x + e, y, x + w - e, y + h), mBlit);
            mC.drawBitmap(b, new Rect(b.getWidth() - e, 0, b.getWidth(), h), new Rect(x + w - e, y, x + w, y + h), mBlit);
        }

        private void drawButtons(boolean ingame)
        {
            for (int i = 0; i < BTN_LABELS.length; i++) {
                if (!ingame && i != BTN_MENU) continue;
                int x = BTN_X0 + i * BTN_STEP;
                boolean sel = (i == mPressed) || (i == mPage && i <= PAGE_MAP);
                button(sel ? "Graphics/Pictures/Party/icon_cancel_sel" : "Graphics/Pictures/Party/icon_cancel", x, BTN_Y, BTN_W);
                String label = BTN_LABELS[i];
                if (i == BTN_SPEED && mState != null) label = "SPEED x" + mState.optInt("speed", 1);
                Typeface tf = label.length() > 5 ? mNarrowFont : mFont;
                text(label, x + BTN_W / 2f, BTN_Y + 8, tf, 27, 2, WHITE, SHADOW);
            }
        }

        /** Small framed caption, used on the map page. */
        private void label(String s, float x, float y, int color, boolean alignRight)
        {
            if (s == null || s.isEmpty()) return;
            mText.setTypeface(mSmallFont);
            mText.setTextSize(21);
            float w = mText.measureText(s) + 16;
            if (alignRight) x -= w;
            RectF r = new RectF(x, y, x + w, y + 28);
            mShape.setStyle(Paint.Style.FILL);
            mShape.setColor(0xd2181428);
            mC.drawRoundRect(r, 8, 8, mShape);
            mShape.setStyle(Paint.Style.STROKE);
            mShape.setStrokeWidth(2);
            mShape.setColor(WHITE);
            mC.drawRoundRect(r, 8, 8, mShape);
            text(s, x + 8, y + 2, mSmallFont, 21, 0, color, SHADOW);
        }

        // ---- Map page: the game's Town Map with the player's position

        private void drawMap()
        {
            // Same frame and position as the game's region map screen, moved
            // up 24 px so it sits above the buttons
            blt("Graphics/Pictures/mapbg", 0, -24);
            JSONObject m = mState.optJSONObject("map");
            if (m == null) {
                label("No map for this area", W / 2f - 100, 160, WHITE, false);
                return;
            }
            Bitmap region = image(m.optString("image", ""));
            int ox = 16, oy = 8;
            if (region != null) {
                ox = (W - region.getWidth()) / 2;
                oy = 8 + (320 - region.getHeight()) / 2;
                mC.drawBitmap(region, ox, oy, mBlit);
            }
            JSONArray extras = m.optJSONArray("extras");
            for (int i = 0; extras != null && i < extras.length(); i++) {
                JSONArray g = extras.optJSONArray(i);
                if (g != null) blt(g.optString(2, ""), ox + g.optInt(0) * 16, oy + g.optInt(1) * 16);
            }
            // point_x_to_screen_x: -8 + x * 16 + map offset
            int px = ox - 8 + m.optInt("x") * 16, py = oy - 8 + m.optInt("y") * 16;
            int frame = (int) ((SystemClock.uptimeMillis() / 300) % 2);
            blt("Graphics/Pictures/mapCursor", px, py, frame * 32, 0, 32, 32, mBlit);
            blt(m.optString("player", ""), px, py);

            label(m.optString("region", ""), 24, 14, GOLD, false);
            JSONObject loc = mState.optJSONObject("location");
            if (loc != null) label(loc.optString("name", ""), 488, 292, WHITE, true);
        }

        // ---- Party page: same layout as the game's party screen (PokemonPartyPanel)

        private void drawParty()
        {
            JSONArray party = mState.optJSONArray("party");
            int count = party == null ? 0 : party.length();
            long t = SystemClock.uptimeMillis();
            for (int i = 0; i < 6; i++) {
                int x = (i % 2) * W / 2;
                int y = 16 * (i % 2) + 96 * (i / 2);
                JSONObject p = (i < count) ? party.optJSONObject(i) : null;
                if (p == null) {
                    blt("Graphics/Pictures/Party/panel_blank", x, y);
                    mShownName[i] = null;
                    continue;
                }
                boolean egg = p.optBoolean("egg", false);
                boolean fainted = p.optBoolean("fainted", false);
                String shape = (i == 0) ? "round" : "rect";
                blt("Graphics/Pictures/Party/panel_" + shape + (fainted ? "_faint" : ""), x, y);

                String ball = p.optString("ball", "");
                Bitmap ballBmp = ball.isEmpty() ? null : image("Graphics/Plugins/Enhanced UI/Party Ball/" + ball);
                if (ballBmp != null) mC.drawBitmap(ballBmp, x + 10, y, mBlit);
                else blt("Graphics/Pictures/Party/icon_ball", x + 10, y);

                // Icon: 2-frame sheet, animates like the game (faster when healthy)
                Bitmap icon = image(p.optString("icon", ""));
                if (icon != null) {
                    int fh = icon.getHeight();
                    int frames = Math.max(1, icon.getWidth() / Math.max(1, fh));
                    int hp = p.optInt("hp", 1), max = Math.max(1, p.optInt("maxhp", 1));
                    long period = fainted ? Long.MAX_VALUE : (hp * 4 <= max ? 400 : hp * 2 <= max ? 250 : 160);
                    int frame = (frames > 1 && period != Long.MAX_VALUE) ? (int) ((t / period) % frames) : 0;
                    int bob = (i == 0 && !fainted && frame == 1) ? -2 : 0;
                    mC.drawBitmap(icon, new Rect(frame * fh, 0, frame * fh + fh, fh),
                        new Rect(x + 60 - fh / 2, y + 40 - fh / 2 + bob, x + 60 + fh / 2, y + 40 + fh / 2 + bob), mBlit);
                }

                if (p.optBoolean("item", false)) blt("Graphics/Pictures/Party/icon_item", x + 62, y + 48);

                text(p.optString("name", ""), x + 96, y + 22);
                if (egg) continue;

                blt("Graphics/Pictures/Party/overlay_hp_back" + (fainted ? "_faint" : ""), x + 96, y + 50);
                blt("Graphics/Pictures/Party/overlay_lv", x + 20, y + 70);
                text(String.valueOf(p.optInt("lv", 1)), x + 42, y + 68, mSmallFont, 21, 0, WHITE, SHADOW);

                int gender = p.optInt("gender", 2);
                if (gender == 0) text("♂", x + 224, y + 22, mFont, 27, 0, 0xff0070f8, 0xff78b8e8);
                else if (gender == 1) text("♀", x + 224, y + 22, mFont, 27, 0, 0xffe82010, 0xfff8a8b8);

                int hp = p.optInt("hp", 0), max = Math.max(1, p.optInt("maxhp", 1));
                // Animate the bar towards the real HP (new Pokemon snap)
                String key = p.optString("name", "") + "/" + max;
                if (!key.equals(mShownName[i])) { mShownName[i] = key; mShownHp[i] = hp; }
                float diff = hp - mShownHp[i];
                mShownHp[i] += Math.signum(diff) * Math.min(Math.abs(diff), Math.max(0.5f, max / 40f));
                int shown = Math.round(mShownHp[i]);
                text(String.format(Locale.US, "%3d /%3d", shown, max), x + 224, y + 66, mFont, 27, 1, WHITE, SHADOW);
                if (shown > 0) {
                    int w = Math.max(1, shown * 96 / max);
                    w = Math.round(w / 2f) * 2;
                    int zone = shown <= max / 4 ? 2 : shown <= max / 2 ? 1 : 0;
                    blt("Graphics/Pictures/Party/overlay_hp", x + 128, y + 52, 0, zone * 8, w, 8, mBlit);
                }

                int status = p.optInt("status", -1);
                if (status >= 0) blt("Graphics/Pictures/statuses", x + 78, y + 68, 0, status * 16, 44, 16, mBlit);
                if (p.optBoolean("shiny", false)) blt("Graphics/Pictures/shiny", x + 80, y + 48, 0, 0, 16, 16, mBlit);
            }
        }

        // ---- Journal page

        private void drawJournal()
        {
            JSONObject loc = mState.optJSONObject("location");
            String sign = loc != null ? loc.optString("sign", "none") : "none";
            String routeNo = loc != null ? loc.optString("route_no", "") : "";
            boolean extended = routeNo.length() >= 3;
            blt("Graphics/Pictures/Location/" + (sign.equals("route") && extended ? "route_extended" : sign), 0, 0);
            if (!routeNo.isEmpty()) {
                int nx = routeNo.length() >= 2 ? 8 : 18;
                for (char ch : routeNo.toCharArray()) {
                    int d = ch - '0';
                    if (d < 0 || d > 9) continue;
                    blt("Graphics/Pictures/Location/icon_numbers", nx, 10, d * 14, 0, 14, 16, mBlit);
                    nx += 14;
                }
            }
            String mapName = loc != null ? loc.optString("name", "") : "";
            text(mapName, extended ? 73 : 59, -4, mFont, 27, 0, 0xffffffff, 0xff737373);

            // Screen-off button in the sign's empty corner
            blt(mPressed == BTN_SCREEN_OFF ? "Graphics/Pictures/Party/icon_cancel_narrow_sel" : "Graphics/Pictures/Party/icon_cancel_narrow", 392, 22);
            text("SCREEN OFF", 448, 26, mNarrowFont, 22, 2, WHITE, SHADOW);

            // Story objective: 4 lines at a time, paged like a message box
            box(8, 66, 340, 180);
            JSONObject q = mState.optJSONObject("quest");
            if (q != null) {
                text(q.optString("name", ""), 20, 72, mNarrowFont, 27, 0, GOLD, GOLD_SHADOW);
                String where = q.optString("location", "");
                if (!where.isEmpty()) text(where, 20, 100, mSmallFont, 21, 0, LILAC, SHADOW);
                String desc = q.optString("desc", "");
                if (!desc.equals(mObjectiveText)) {
                    mObjectiveText = desc;
                    mObjectiveLines = wrap(desc, mSmallFont, 21, 300);
                    mObjectivePage = 0;
                    mObjectivePageAt = SystemClock.uptimeMillis();
                }
                int pages = Math.max(1, (mObjectiveLines.size() + LINES_PER_PAGE - 1) / LINES_PER_PAGE);
                long now = SystemClock.uptimeMillis();
                if (pages > 1 && now - mObjectivePageAt > 7000) nextObjectivePage();
                mObjectivePage %= pages;
                int first = mObjectivePage * LINES_PER_PAGE;
                for (int i = 0; i < LINES_PER_PAGE && first + i < mObjectiveLines.size(); i++) {
                    text(mObjectiveLines.get(first + i), 20, 126 + i * 23, mSmallFont, 21, 0, WHITE, SHADOW);
                }
                if (pages > 1 && (now / 400) % 2 == 0) {
                    android.graphics.Path arrow = new android.graphics.Path();
                    arrow.moveTo(326, 228);
                    arrow.lineTo(338, 228);
                    arrow.lineTo(332, 236);
                    arrow.close();
                    mShape.setStyle(Paint.Style.FILL);
                    mShape.setColor(WHITE);
                    mC.drawPath(arrow, mShape);
                }
            } else {
                text("No active quest", 20, 72, mNarrowFont, 27, 0, GOLD, GOLD_SHADOW);
            }

            // Trainer
            box(356, 66, 148, 180);
            text(mState.optString("player", ""), 368, 72);
            text(String.format(Locale.US, "$%,d", mState.optLong("money", 0)), 368, 102, mSmallFont, 21, 0, WHITE, SHADOW);
            long pt = mState.optLong("playtime", 0);
            text(String.format(Locale.US, "Play %d:%02d", pt / 3600, (pt / 60) % 60), 368, 126, mSmallFont, 21, 0, WHITE, SHADOW);
            JSONObject clock = mState.optJSONObject("clock");
            if (clock != null) {
                text(clock.optString("time", ""), 368, 152, mFont, 27, 0, GOLD, GOLD_SHADOW);
                String tod = clock.optString("tod", "");
                int todColor = "Night".equals(tod) ? 0xff90a8f8 : "Evening".equals(tod) ? 0xffe8a060
                    : "Morning".equals(tod) ? 0xfff8e0a0 : 0xfff8f8a0;
                text(tod, 368, 180, mSmallFont, 21, 0, todColor, SHADOW);
                text(clock.optString("season", ""), 368, 204, mSmallFont, 21, 0, LILAC, SHADOW);
            }

            // Chapters (Trainer Card badge sheet: 9 per row, 32x32)
            box(8, 250, 496, 76);
            JSONArray badges = mState.optJSONArray("badges");
            for (int i = 0; i < 18; i++) {
                boolean got = badges != null && badges.optBoolean(i, false);
                int sx = (i % 9) * 32, sy = (i / 9) * 32;
                int bx = 28 + (i % 9) * 52, by = 255 + (i / 9) * 34;
                Bitmap b = image("Graphics/Pictures/Trainer Card/icon_badges");
                if (b != null) {
                    mC.drawBitmap(b, new Rect(sx, sy, sx + 32, sy + 32), new Rect(bx, by, bx + 32, by + 32),
                        got ? mBlit : mDim);
                }
            }
        }

        // --------------------------------------------------------------- input

        private int hit(float vx, float vy)
        {
            if (vy >= BTN_Y && vy < BTN_Y + BTN_H) {
                for (int i = 0; i < BTN_LABELS.length; i++) {
                    int x = BTN_X0 + i * BTN_STEP;
                    if (vx >= x && vx < x + BTN_W) return i;
                }
            }
            if (mPage == PAGE_JOURNAL && vx >= 392 && vx < 504 && vy >= 22 && vy < 58) return BTN_SCREEN_OFF;
            if (mPage == PAGE_JOURNAL && vx >= 8 && vx < 348 && vy >= 66 && vy < 246) return BTN_OBJECTIVE;
            return -1;
        }

        private void sendKey(int keycode, boolean down)
        {
            if (down) SDLActivity.onNativeKeyDown(keycode);
            else SDLActivity.onNativeKeyUp(keycode);
        }

        @SuppressLint("ClickableViewAccessibility")
        @Override
        public boolean onTouchEvent(MotionEvent e)
        {
            if (!mScreenOn) {
                if (e.getActionMasked() == MotionEvent.ACTION_UP) setScreenOn(true);
                return true;
            }
            float vx = (e.getX() - mDst.left) * W / Math.max(1f, mDst.width());
            float vy = (e.getY() - mDst.top) * H / Math.max(1f, mDst.height());
            boolean ingame = mState != null && mState.optBoolean("ingame", false);

            switch (e.getActionMasked()) {
                case MotionEvent.ACTION_DOWN: {
                    int b = hit(vx, vy);
                    if (!ingame && b != BTN_MENU) b = -1;
                    mPressed = b;
                    // Menu and Speed act like holding the game's key
                    if (b == BTN_MENU) sendKey(KeyEvent.KEYCODE_X, true);
                    if (b == BTN_SPEED) sendKey(KeyEvent.KEYCODE_Q, true);
                    return true;
                }
                case MotionEvent.ACTION_UP:
                case MotionEvent.ACTION_CANCEL: {
                    int b = mPressed;
                    mPressed = -1;
                    if (b == BTN_MENU) sendKey(KeyEvent.KEYCODE_X, false);
                    if (b == BTN_SPEED) sendKey(KeyEvent.KEYCODE_Q, false);
                    if (e.getActionMasked() == MotionEvent.ACTION_UP && hit(vx, vy) == b) {
                        if (b >= PAGE_PARTY && b <= PAGE_MAP) setPage(b);
                        if (b == BTN_SCREEN_OFF) setScreenOn(false);
                        if (b == BTN_OBJECTIVE) nextObjectivePage();
                    }
                    return true;
                }
            }
            return true;
        }

        private void setPage(int page)
        {
            mPage = page;
            mPrefs.edit().putInt("page", page).apply();
            Log.i(TAG, "Page " + (page == PAGE_JOURNAL ? "journal" : page == PAGE_MAP ? "map" : "party"));
        }

        private void setScreenOn(boolean on)
        {
            mScreenOn = on;
            mPrefs.edit().putBoolean("panel_on", on).apply();
            Log.i(TAG, "Second screen " + (on ? "on" : "off"));
            invalidate();
        }
    }
}
