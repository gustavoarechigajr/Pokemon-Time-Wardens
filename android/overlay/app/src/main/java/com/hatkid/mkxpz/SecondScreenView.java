package com.hatkid.mkxpz;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Typeface;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * The second game screen (dual-screen devices such as the AYN Thor), drawn
 * with the game's own graphics and fonts at the game's 512x384 resolution and
 * scaled up pixel-perfect.
 *
 * Pages: PARTY (with summaries, items, swapping), JOURNAL (objective + quest
 * log), MAP (Town Map, Fly), ROUTE (encounters), LOG (recent dialogue), MORE
 * (menu, save, speed, Repel, key items, screen off), plus BATTLE controls and
 * a KEYBOARD that open automatically.
 *
 * Game -> screen: Mods/Android_DualScreen.rb writes .tw_status.json.
 * Screen -> game: commands are written as .tw_cmd_*.txt files ("key=value"
 * lines) which the game runs only when it is safe to.
 */
@SuppressLint("ViewConstructor")
public class SecondScreenView extends View
{
    private static final String TAG = "TimeWardens[Dual]";
    static final int W = 512, H = 384;

    // Pages
    static final int P_PARTY = 0, P_JOURNAL = 1, P_MAP = 2, P_ROUTE = 3, P_LOG = 4, P_MORE = 5;
    static final String[] TABS = { "PARTY", "JOURNAL", "MAP", "ROUTE", "LOG", "MORE" };
    static final int BAR_Y = 334, BAR_H = 46, TAB_W = 80, TAB_STEP = 85, TAB_X0 = 2;

    // Overlays on top of a page
    static final int O_NONE = 0, O_SUMMARY = 1, O_ITEMS = 2, O_QUESTS = 3;

    static final int WHITE = 0xfff8f8f8, SHADOW = 0xff282828;
    static final int GOLD = 0xfff8d060, GOLD_SHADOW = 0xff604010;
    static final int LILAC = 0xffc8c8e8, DIM = 0xff8888a8;
    static final int GREEN = 0xff70e070, RED = 0xfff07060;

    private final File mGameDir;
    private final File mStatusFile;
    private final boolean mDemo;
    private long mLastDemoShot;
    private Bitmap mDemoPrev;
    private int mDemoShotSeq;
    private final SharedPreferences mPrefs;
    private final Handler mHandler = new Handler(Looper.getMainLooper());

    private final Bitmap mCanvasBmp = Bitmap.createBitmap(W, H, Bitmap.Config.ARGB_8888);
    private final Canvas mC = new Canvas(mCanvasBmp);
    private final Paint mBlit = new Paint();
    private final Paint mText = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint mShape = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Paint mDark = new Paint();
    private final Map<String, Bitmap> mImages = new HashMap<>();
    private final Typeface mFont, mSmallFont, mNarrowFont;
    private final Rect mDst = new Rect();

    private JSONObject mState;
    private long mLastModified = -1;
    private long mLastPoll = 0;
    private int mCmdSeq = 0;

    private int mPage;
    private int mOverlay = O_NONE;
    private boolean mScreenOn;
    private boolean mBattlePage = false;      // showing battle controls
    private boolean mBattleAuto = true;       // switch to battle page when a battle starts
    private String mLastContext = "";

    // Party / summary
    private int mSelected = -1;               // Pokémon whose summary is open
    private int mSwapFrom = -1;               // first Pokémon picked for a swap
    private int mSummaryTab = 0;
    private final float[] mShownHp = new float[6];
    private final String[] mShownKey = new String[6];

    // Journal objective paging
    private String mObjectiveText;
    private List<String> mObjectiveLines = new ArrayList<>();
    private int mObjectivePage;
    private long mObjectivePageAt;

    // Map
    private int mMapPoint = -1;

    // Keyboard
    private boolean mShift = true;

    // Scrolling lists
    private final int[] mScroll = new int[8];
    private int mScrollMax = 0;
    private int mScrollKey = -1;

    // Toasts
    private int mToastId = -1;
    private String mToastText;
    private long mToastUntil;

    // Touch
    private static class Hit
    {
        final RectF r; final Runnable action; final int id;
        Hit(RectF r, int id, Runnable action) { this.r = r; this.id = id; this.action = action; }
    }
    private final List<Hit> mHits = new ArrayList<>();
    private int mPressed = -1;
    private float mDownX, mDownY, mLastY;
    private boolean mDragging;

    private final Runnable mTick = new Runnable() {
        @Override public void run() {
            long now = SystemClock.uptimeMillis();
            if (now - mLastPoll >= 150) {
                mLastPoll = now;
                poll();
            }
            invalidate();
            mHandler.postDelayed(this, mScreenOn ? 50 : 500);
        }
    };

    public SecondScreenView(Context ctx, File gameDir, File statusFile, String demo)
    {
        super(ctx);
        mGameDir = gameDir;
        mStatusFile = statusFile;
        mDemo = demo != null;
        mPrefs = ctx.getSharedPreferences("dualscreen", Context.MODE_PRIVATE);
        mPage = Math.max(0, Math.min(TABS.length - 1, mPrefs.getInt("page2", P_PARTY)));
        mScreenOn = mPrefs.getBoolean("panel_on", true);
        mBlit.setFilterBitmap(false);
        mFont = font("Fonts/power green.ttf");
        mSmallFont = font("Fonts/power green small.ttf");
        mNarrowFont = font("Fonts/power green narrow.ttf");
        ColorMatrix cm = new ColorMatrix();
        cm.setScale(0f, 0f, 0f, 0.55f);   // silhouette for unseen Pokémon / dimmed badges
        mDark.setColorFilter(new ColorMatrixColorFilter(cm));
        mDark.setFilterBitmap(false);
        if (mDemo) loadDemo(ctx, demo);
    }

    private void loadDemo(Context ctx, String variant)
    {
        try (java.io.InputStream in = ctx.getAssets().open("tw_demo_status.json")) {
            byte[] data = new byte[in.available()];
            int n = 0, r;
            while (n < data.length && (r = in.read(data, n, data.length - n)) > 0) n += r;
            mState = new JSONObject(new String(data, 0, n, StandardCharsets.UTF_8));
            // The sample is mid-battle at the command menu; variants:
            switch (variant) {
                case "fight":
                    mState.put("battle", mState.optJSONObject("battle_fight"));
                    mBattlePage = true;
                    break;
                case "map":
                    mState.put("context", "map");
                    mState.remove("battle");
                    break;
                case "entry":
                    mState.put("context", "entry");
                    mState.put("entry", new JSONObject().put("text", "Gus").put("max", 7).put("min", 1));
                    break;
                default:
                    mBattlePage = true;
                    break;
            }
            Log.i(TAG, "Demo status loaded (" + variant + ")");
        } catch (Exception e) {
            Log.w(TAG, "No demo status: " + e);
        }
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

    // =====================================================================
    // Data in / commands out
    // =====================================================================

    private void poll()
    {
        if (mDemo) return;
        long mod = mStatusFile.lastModified();
        if (mod == 0 || mod == mLastModified) return;
        mLastModified = mod;
        try (FileInputStream in = new FileInputStream(mStatusFile)) {
            byte[] data = new byte[(int) Math.min(mStatusFile.length(), 4 << 20)];
            int n = 0, r;
            while (n < data.length && (r = in.read(data, n, data.length - n)) > 0) n += r;
            JSONObject prev = mState;
            mState = new JSONObject(new String(data, 0, n, StandardCharsets.UTF_8));
            String ctx = mState.optString("context", "");
            if (prev == null || !ctx.equals(mLastContext)) {
                JSONArray party = mState.optJSONArray("party");
                JSONObject loc = mState.optJSONObject("location");
                Log.i(TAG, "Status: ingame=" + mState.optBoolean("ingame", false) + " context=" + ctx
                    + " party=" + (party != null ? party.length() : 0)
                    + " location=" + (loc != null ? loc.optString("name") : "")
                    + " map=" + (mState.optJSONObject("map") != null));
                onContextChange(mLastContext, ctx);
                mLastContext = ctx;
            }
        } catch (Exception e) {
            Log.w(TAG, "Status file: " + e);
        }
    }

    private void onContextChange(String from, String to)
    {
        if ("battle".equals(to) && !"battle".equals(from) && mBattleAuto) {
            mBattlePage = true;
            mOverlay = O_NONE;
        } else if (!"battle".equals(to)) {
            mBattlePage = false;
        }
    }

    /** Sends a command to the game (see Mods/Android_DualScreen.rb). */
    private void command(String... kv)
    {
        if (mDemo) {
            Log.i(TAG, "Demo command: " + String.join(" ", kv));
            return;
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i + 1 < kv.length; i += 2) sb.append(kv[i]).append('=').append(kv[i + 1]).append('\n');
        String name = String.format(Locale.US, ".tw_cmd_%d_%03d.txt", System.currentTimeMillis(), (mCmdSeq++) % 1000);
        File tmp = new File(mGameDir, name + ".tmp");
        try (FileOutputStream os = new FileOutputStream(tmp)) {
            os.write(sb.toString().getBytes(StandardCharsets.UTF_8));
        } catch (Exception e) {
            Log.w(TAG, "Command write failed: " + e);
            return;
        }
        if (!tmp.renameTo(new File(mGameDir, name))) tmp.delete();
        Log.i(TAG, "Command: " + sb.toString().replace('\n', ' ').trim());
    }

    private boolean ingame() { return mState != null && mState.optBoolean("ingame", false); }
    private String context() { return mState != null ? mState.optString("context", "title") : "title"; }
    private boolean free() { return "map".equals(context()); }

    // =====================================================================
    // Images / text helpers
    // =====================================================================

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
        if (mImages.size() > 160) mImages.clear();
        mImages.put(rel, b);
        return b;
    }

    private void blt(String rel, float x, float y)
    {
        Bitmap b = image(rel);
        if (b != null) mC.drawBitmap(b, x, y, mBlit);
    }

    private void blt(String rel, int x, int y, int sx, int sy, int sw, int sh, int dw, int dh, Paint p)
    {
        Bitmap b = image(rel);
        if (b == null || sw <= 0 || sh <= 0) return;
        mC.drawBitmap(b, new Rect(sx, sy, sx + sw, sy + sh), new Rect(x, y, x + dw, y + dh), p);
    }

    /** A Pokémon icon (2-frame sheet), first frame unless animate. */
    private void icon(String rel, float cx, float cy, int size, boolean animate, Paint p)
    {
        Bitmap b = image(rel);
        if (b == null) return;
        int fh = b.getHeight();
        int frames = Math.max(1, b.getWidth() / Math.max(1, fh));
        int frame = animate && frames > 1 ? (int) ((SystemClock.uptimeMillis() / 200) % frames) : 0;
        int s = size > 0 ? size : fh;
        mC.drawBitmap(b, new Rect(frame * fh, 0, frame * fh + fh, fh),
            new RectF(cx - s / 2f, cy - s / 2f, cx + s / 2f, cy + s / 2f), p != null ? p : mBlit);
    }

    /** Like the game's pbDrawTextPositions: shadow at +2 offsets, y = top of text. */
    private float text(String s, float x, float y, Typeface tf, float size, int align, int base, int shadow)
    {
        if (s == null || s.isEmpty()) return 0;
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
        return w;
    }

    private void text(String s, float x, float y) { text(s, x, y, mFont, 27, 0, WHITE, SHADOW); }
    private void small(String s, float x, float y, int color) { text(s, x, y, mSmallFont, 21, 0, color, SHADOW); }
    private void small(String s, float x, float y, int color, int align) { text(s, x, y, mSmallFont, 21, align, color, SHADOW); }

    private float measure(String s, Typeface tf, float size)
    {
        mText.setTypeface(tf);
        mText.setTextSize(size);
        return mText.measureText(s);
    }

    private String ellipsize(String s, Typeface tf, float size, float width)
    {
        if (measure(s, tf, size) <= width) return s;
        while (s.length() > 1 && measure(s + "...", tf, size) > width) s = s.substring(0, s.length() - 1);
        return s + "...";
    }

    private List<String> wrap(String s, Typeface tf, float size, float width)
    {
        List<String> out = new ArrayList<>();
        StringBuilder line = new StringBuilder();
        for (String word : s.split(" ")) {
            String t = line.length() == 0 ? word : line + " " + word;
            if (measure(t, tf, size) <= width || line.length() == 0) {
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

    private void box(float x, float y, float w, float h)
    {
        box(x, y, w, h, 0xdc1e1834);
    }

    private void box(float x, float y, float w, float h, int fill)
    {
        RectF r = new RectF(x + 1, y + 1, x + w - 1, y + h - 1);
        mShape.setStyle(Paint.Style.FILL);
        mShape.setColor(fill);
        mC.drawRoundRect(r, 10, 10, mShape);
        mShape.setStyle(Paint.Style.STROKE);
        mShape.setStrokeWidth(2);
        mShape.setColor(WHITE);
        mC.drawRoundRect(r, 10, 10, mShape);
    }

    private void fillRect(float x, float y, float w, float h, int color)
    {
        mShape.setStyle(Paint.Style.FILL);
        mShape.setColor(color);
        mC.drawRect(x, y, x + w, y + h, mShape);
    }

    /** The party screen's button graphic stretched horizontally (end caps kept). */
    private void buttonArt(boolean sel, float x, float y, float w, float h)
    {
        Bitmap b = image(sel ? "Graphics/Pictures/Party/icon_cancel_sel" : "Graphics/Pictures/Party/icon_cancel");
        if (b == null) { box(x, y, w, h, sel ? 0xff6a5a8a : 0xff3a3050); return; }
        int bh = b.getHeight(), e = 12;
        float sy = h / bh;
        int ex = (int) (e * Math.min(1f, sy));
        mC.drawBitmap(b, new Rect(0, 0, e, bh), new RectF(x, y, x + ex, y + h), mBlit);
        mC.drawBitmap(b, new Rect(e, 0, b.getWidth() - e, bh), new RectF(x + ex, y, x + w - ex, y + h), mBlit);
        mC.drawBitmap(b, new Rect(b.getWidth() - e, 0, b.getWidth(), bh), new RectF(x + w - ex, y, x + w, y + h), mBlit);
    }

    private int mHitSeq = 0;

    /** Draws a button and registers its tap action. */
    private void button(String label, float x, float y, float w, float h, boolean enabled, boolean selected, Runnable action)
    {
        int id = mHitSeq++;
        boolean pressed = enabled && mPressed == id;
        buttonArt(selected || pressed, x, y, w, h);
        Typeface tf = measure(label, mFont, 27) > w - 12 ? mNarrowFont : mFont;
        float size = 27;
        while (size > 16 && measure(label, tf, size) > w - 10) size -= 1;
        mText.setTypeface(tf);
        mText.setTextSize(size);
        float ty = y + (h - (mText.descent() - mText.ascent())) / 2f;
        text(label, x + w / 2f, ty, tf, size, 2, enabled ? WHITE : DIM, SHADOW);
        if (enabled && action != null) mHits.add(new Hit(new RectF(x, y, x + w, y + h), id, action));
    }

    private void hit(float x, float y, float w, float h, Runnable action)
    {
        mHits.add(new Hit(new RectF(x, y, x + w, y + h), mHitSeq++, action));
    }

    private void hpBar(float x, float y, float w, float frac)
    {
        frac = Math.max(0f, Math.min(1f, frac));
        fillRect(x, y, w, 8, 0xff303038);
        int color = frac > 0.5f ? 0xff40d060 : frac > 0.2f ? 0xfff0c030 : 0xffe04040;
        if (frac > 0) fillRect(x, y, Math.max(2, w * frac), 8, color);
    }

    /** Type icon from Graphics/Pictures/types.png (64x28 per row). */
    private void typeIcon(JSONObject type, float x, float y, float w)
    {
        if (type == null) return;
        int row = type.optInt("icon", 0);
        blt("Graphics/Pictures/types", (int) x, (int) y, 0, row * 28, 64, 28, (int) w, (int) (w * 28 / 64), mBlit);
    }

    private void categoryIcon(int cat, float x, float y, float w)
    {
        blt("Graphics/Pictures/category", (int) x, (int) y, 0, cat * 28, 64, 28, (int) w, (int) (w * 28 / 64), mBlit);
    }

    private static String mb(long n) { return String.format(Locale.US, "%,d", n); }

    // =====================================================================
    // Drawing
    // =====================================================================

    @Override
    protected void onDraw(Canvas canvas)
    {
        canvas.drawColor(Color.BLACK);
        mHits.clear();
        mHitSeq = 0;
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
        try {
            draw();
        } catch (Exception e) {
            Log.w(TAG, "Draw failed", e);
        }
        drawToast();

        float scale = Math.min(getWidth() / (float) W, getHeight() / (float) H);
        int dw = (int) (W * scale), dh = (int) (H * scale);
        int dx = (getWidth() - dw) / 2, dy = (getHeight() - dh) / 2;
        mDst.set(dx, dy, dx + dw, dy + dh);
        canvas.drawBitmap(mCanvasBmp, null, mDst, mBlit);
        if (mDemo) saveDemoShot();
    }

    /**
     * Demo mode only: logs the page as a JPEG (base64, in chunks) whenever it
     * changes, so the emulator test can capture it. Overlay displays can't
     * be captured with screencap and app files aren't readable over adb.
     */
    private void saveDemoShot()
    {
        long now = SystemClock.uptimeMillis();
        if (now - mLastDemoShot < 1000) return;
        mLastDemoShot = now;
        if (mDemoPrev != null && mDemoPrev.sameAs(mCanvasBmp)) return;
        mDemoPrev = mCanvasBmp.copy(Bitmap.Config.ARGB_8888, false);
        java.io.ByteArrayOutputStream out = new java.io.ByteArrayOutputStream();
        mCanvasBmp.compress(Bitmap.CompressFormat.JPEG, 85, out);
        String b64 = android.util.Base64.encodeToString(out.toByteArray(), android.util.Base64.NO_WRAP);
        int seq = ++mDemoShotSeq, n = (b64.length() + 3499) / 3500;
        for (int i = 0; i < n; i++) {
            Log.i("TWShot", seq + " " + (i + 1) + "/" + n + " " + b64.substring(i * 3500, Math.min(b64.length(), (i + 1) * 3500)));
        }
    }

    private void draw()
    {
        if (!ingame()) {
            blt("Graphics/Titles/title", 0, 0);
            return;
        }
        String ctx = context();
        if ("entry".equals(ctx) && mState.optJSONObject("entry") != null) {
            drawKeyboard();
            return;
        }
        if (mBattlePage && "battle".equals(ctx) && mState.optJSONObject("battle") != null) {
            drawBattle();
        } else if (mOverlay == O_SUMMARY) {
            drawSummary();
        } else if (mOverlay == O_ITEMS) {
            drawItems();
        } else if (mOverlay == O_QUESTS) {
            drawQuestLog();
        } else {
            switch (mPage) {
                case P_JOURNAL: drawJournal(); break;
                case P_MAP: drawMap(); break;
                case P_ROUTE: drawRoute(); break;
                case P_LOG: drawLog(); break;
                case P_MORE: drawMore(); break;
                default: drawParty(); break;
            }
        }
        drawTabs();
    }

    private void drawTabs()
    {
        boolean battle = "battle".equals(context());
        for (int i = 0; i < TABS.length; i++) {
            final int page = i;
            String label = TABS[i];
            boolean sel = mOverlay == O_NONE && !mBattlePage && mPage == i;
            if (battle && i == 0) {
                label = mBattlePage ? "PARTY" : "BATTLE";
                sel = false;
            }
            final boolean toBattle = battle && i == 0 && !mBattlePage;
            button(label, TAB_X0 + i * TAB_STEP, BAR_Y, TAB_W, BAR_H, true, sel, () -> {
                mOverlay = O_NONE;
                mSwapFrom = -1;
                if (toBattle) {
                    mBattlePage = true;
                    mBattleAuto = true;
                    return;
                }
                if (mBattlePage) mBattleAuto = false;   // player chose to look elsewhere this battle
                mBattlePage = false;
                setPage(page);
            });
        }
    }

    private void setPage(int page)
    {
        mPage = page;
        mPrefs.edit().putInt("page2", page).apply();
        Log.i(TAG, "Page " + TABS[page].toLowerCase(Locale.ROOT));
    }

    private void drawToast()
    {
        if (mState == null) return;
        JSONObject t = mState.optJSONObject("toast");
        if (t != null && t.optInt("id", -1) != mToastId) {
            mToastId = t.optInt("id", -1);
            if (mToastId > 0 && mLastModified > 0) {
                mToastText = t.optString("text", "");
                mToastUntil = SystemClock.uptimeMillis() + 2500;
            }
        }
        if (mToastText != null && SystemClock.uptimeMillis() < mToastUntil) {
            float w = Math.min(480, measure(mToastText, mSmallFont, 21) + 32);
            box(W / 2f - w / 2, 290, w, 36, 0xf0302848);
            small(mToastText, W / 2f, 297, WHITE, 2);
        }
    }

    // ---- Party (same layout as the game's party screen) ----------------

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
                mShownKey[i] = null;
                continue;
            }
            boolean egg = p.optBoolean("egg", false);
            boolean fainted = p.optBoolean("fainted", false);
            String shape = (i == 0) ? "round" : "rect";
            boolean swapSel = mSwapFrom == i;
            blt("Graphics/Pictures/Party/panel_" + shape + (swapSel ? "_swap_sel" : mSwapFrom >= 0 ? "_swap" : fainted ? "_faint" : ""), x, y);

            String ball = p.optString("ball", "");
            Bitmap ballBmp = ball.isEmpty() ? null : image("Graphics/Plugins/Enhanced UI/Party Ball/" + ball);
            if (ballBmp != null) mC.drawBitmap(ballBmp, x + 10, y, mBlit);
            else blt("Graphics/Pictures/Party/icon_ball", x + 10, y);

            Bitmap ic = image(p.optString("icon", ""));
            if (ic != null) {
                int fh = ic.getHeight();
                int frames = Math.max(1, ic.getWidth() / Math.max(1, fh));
                int hp = p.optInt("hp", 1), max = Math.max(1, p.optInt("maxhp", 1));
                long period = fainted ? Long.MAX_VALUE : (hp * 4 <= max ? 400 : hp * 2 <= max ? 250 : 160);
                int frame = (frames > 1 && period != Long.MAX_VALUE) ? (int) ((t / period) % frames) : 0;
                int bob = (i == 0 && !fainted && frame == 1) ? -2 : 0;
                mC.drawBitmap(ic, new Rect(frame * fh, 0, frame * fh + fh, fh),
                    new Rect(x + 60 - fh / 2, y + 40 - fh / 2 + bob, x + 60 + fh / 2, y + 40 + fh / 2 + bob), mBlit);
            }
            if (p.optBoolean("item", false)) blt("Graphics/Pictures/Party/icon_item", x + 62, y + 48);
            String pname = p.optString("name", "");
            // Long names switch to the narrow font so they clear the gender mark
            Typeface nameFont = measure(pname, mFont, 27) > 124 ? mNarrowFont : mFont;
            text(ellipsize(pname, nameFont, 27, 126), x + 96, y + 22, nameFont, 27, 0, WHITE, SHADOW);

            if (!egg) {
                blt("Graphics/Pictures/Party/overlay_hp_back" + (fainted ? "_faint" : ""), x + 96, y + 50);
                blt("Graphics/Pictures/Party/overlay_lv", x + 20, y + 70);
                text(String.valueOf(p.optInt("lv", 1)), x + 42, y + 68, mSmallFont, 21, 0, WHITE, SHADOW);
                int gender = p.optInt("gender", 2);
                if (gender == 0) text("♂", x + 224, y + 22, mFont, 27, 0, 0xff0070f8, 0xff78b8e8);
                else if (gender == 1) text("♀", x + 224, y + 22, mFont, 27, 0, 0xffe82010, 0xfff8a8b8);
                int hp = p.optInt("hp", 0), max = Math.max(1, p.optInt("maxhp", 1));
                String key = p.optString("name", "") + "/" + max;
                if (!key.equals(mShownKey[i])) { mShownKey[i] = key; mShownHp[i] = hp; }
                float diff = hp - mShownHp[i];
                mShownHp[i] += Math.signum(diff) * Math.min(Math.abs(diff), Math.max(0.5f, max / 40f));
                int shown = Math.round(mShownHp[i]);
                text(String.format(Locale.US, "%3d /%3d", shown, max), x + 224, y + 66, mFont, 27, 1, WHITE, SHADOW);
                if (shown > 0) {
                    int w = Math.max(1, shown * 96 / max);
                    w = Math.round(w / 2f) * 2;
                    int zone = shown <= max / 4 ? 2 : shown <= max / 2 ? 1 : 0;
                    blt("Graphics/Pictures/Party/overlay_hp", x + 128, y + 52, 0, zone * 8, w, 8, w, 8, mBlit);
                }
                int status = p.optInt("status", -1);
                if (status >= 0) blt("Graphics/Pictures/statuses", x + 78, y + 68, 0, status * 16, 44, 16, 44, 16, mBlit);
                if (p.optBoolean("shiny", false)) blt("Graphics/Pictures/shiny", x + 80, y + 48, 0, 0, 16, 16, 16, 16, mBlit);
            }

            final int idx = i;
            hit(x, y, 256, 96, () -> {
                if (mSwapFrom >= 0) {
                    if (mSwapFrom != idx) command("cmd", "swap", "a", String.valueOf(mSwapFrom), "b", String.valueOf(idx));
                    mSwapFrom = -1;
                } else {
                    mSelected = idx;
                    mSummaryTab = 0;
                    mOverlay = O_SUMMARY;
                }
            });
        }
        if (mSwapFrom >= 0) {
            box(96, 298, 320, 32, 0xf0302848);
            small("Tap a Pokémon to swap with", W / 2f, 304, GOLD, 2);
        }
    }

    private JSONObject selectedPokemon()
    {
        JSONArray party = mState.optJSONArray("party");
        if (party == null || mSelected < 0 || mSelected >= party.length()) return null;
        return party.optJSONObject(mSelected);
    }

    // ---- Summary --------------------------------------------------------

    private void drawSummary()
    {
        JSONObject p = selectedPokemon();
        if (p == null) { mOverlay = O_NONE; drawParty(); return; }
        boolean egg = p.optBoolean("egg", false);

        // Left: portrait
        box(6, 6, 186, 236);
        Bitmap front = image(p.optString("front", ""));
        if (front != null && !egg) {
            int fw = front.getWidth(), fh = front.getHeight();
            int fs = Math.min(fw, fh);
            float s = 160f / fs;
            mC.drawBitmap(front, new Rect(0, 0, fs, fs), new RectF(19, 14, 19 + fs * s, 14 + fs * s), mBlit);
        } else {
            icon(p.optString("icon", ""), 99, 94, 128, true, null);
        }
        text(ellipsize(p.optString("name", ""), mFont, 27, 160), 99, 178, mFont, 27, 2, WHITE, SHADOW);
        if (!egg) {
            String sub = "Lv." + p.optInt("lv", 1);
            int g = p.optInt("gender", 2);
            small(sub + (g == 0 ? "  ♂" : g == 1 ? "  ♀" : ""), 99, 206, LILAC, 2);
            if (p.optBoolean("shiny", false)) blt("Graphics/Pictures/shiny", 20, 20, 0, 0, 16, 16, 16, 16, mBlit);
        }

        // Right: tabs
        String[] tabs = { "INFO", "STATS", "MOVES" };
        for (int i = 0; i < tabs.length; i++) {
            final int tab = i;
            button(tabs[i], 200 + i * 104, 6, 100, 34, !egg, mSummaryTab == i, () -> mSummaryTab = tab);
        }
        box(198, 44, 308, 198);
        if (egg) {
            small("This Egg needs more time to hatch.", 210, 56, WHITE);
            small("Keep it in your party while walking!", 210, 82, LILAC);
        } else if (mSummaryTab == 1) {
            drawSummaryStats(p);
        } else if (mSummaryTab == 2) {
            drawSummaryMoves(p);
        } else {
            drawSummaryInfo(p);
        }

        // Actions
        boolean can = free();
        button("USE ITEM", 6, 250, 160, 40, can && !egg, false, () -> { mOverlay = O_ITEMS; mScroll[O_ITEMS] = 0; });
        button("SWAP", 176, 250, 160, 40, can, false, () -> { mSwapFrom = mSelected; mOverlay = O_NONE; setPage(P_PARTY); });
        button("CLOSE", 346, 250, 160, 40, true, false, () -> mOverlay = O_NONE);
        if (!can) {
            box(6, 294, 500, 34);
            text("Items and swapping work while you're free to move.", W / 2f, 300, mSmallFont, 17, 2, DIM, SHADOW);
        }
    }

    private void drawSummaryInfo(JSONObject p)
    {
        float y = 50;
        small("Species", 210, y, DIM); small(p.optString("species", ""), 330, y, WHITE); y += 26;
        small("Type", 210, y, DIM);
        JSONArray types = p.optJSONArray("types");
        for (int i = 0; types != null && i < types.length(); i++) typeIcon(types.optJSONObject(i), 330 + i * 70, y + 1, 64);
        y += 30;
        small("Nature", 210, y, DIM); small(p.optString("nature", ""), 330, y, WHITE); y += 26;
        small("Item", 210, y, DIM);
        small(p.optString("item_name", "").isEmpty() ? "None" : p.optString("item_name", ""), 330, y, WHITE); y += 26;
        small("Ability", 210, y, DIM); small(p.optString("ability", ""), 330, y, GOLD); y += 24;
        List<String> lines = wrap(p.optString("ability_desc", ""), mSmallFont, 19, 284);
        for (int i = 0; i < Math.min(2, lines.size()); i++) text(lines.get(i), 210, y + i * 20, mSmallFont, 19, 0, LILAC, SHADOW);
        y = 214;
        small("Exp.", 210, y, DIM);
        fillRect(260, y + 8, 236, 6, 0xff303038);
        fillRect(260, y + 8, 236 * (float) Math.max(0, Math.min(1, p.optDouble("exp_frac", 0))), 6, 0xff48a8f8);
    }

    private void drawSummaryStats(JSONObject p)
    {
        String[] names = { "HP", "Attack", "Defense", "Sp. Atk", "Sp. Def", "Speed" };
        JSONArray stats = p.optJSONArray("stats"), ivs = p.optJSONArray("ivs"), evs = p.optJSONArray("evs");
        small("IV", 412, 50, DIM, 2);
        small("EV", 468, 50, DIM, 2);
        for (int i = 0; i < 6; i++) {
            float y = 74 + i * 26;
            small(names[i], 210, y, DIM);
            String v = i == 0 ? p.optInt("hp", 0) + "/" + (stats != null ? stats.optInt(0) : 0) : String.valueOf(stats != null ? stats.optInt(i) : 0);
            small(v, 380, y, WHITE, 1);
            small(String.valueOf(ivs != null ? ivs.optInt(i) : 0), 412, y, LILAC, 2);
            small(String.valueOf(evs != null ? evs.optInt(i) : 0), 468, y, LILAC, 2);
        }
        hpBar(210, 234, 286, p.optInt("hp", 0) / (float) Math.max(1, p.optInt("maxhp", 1)));
    }

    private void drawSummaryMoves(JSONObject p)
    {
        JSONArray moves = p.optJSONArray("moves");
        for (int i = 0; i < 4; i++) {
            float y = 50 + i * 47;
            JSONObject m = moves != null && i < moves.length() ? moves.optJSONObject(i) : null;
            if (m == null) { small("-", 290, y + 8, DIM); continue; }
            typeIcon(m.optJSONObject("type"), 206, y + 2, 64);
            categoryIcon(m.optInt("cat", 2), 218, y + 30, 40);   // under the type, clear of the name
            String pp = "PP " + m.optInt("pp") + "/" + m.optInt("maxpp");
            float ppw = text(pp, 500, y + 2, mSmallFont, 18, 1, LILAC, SHADOW);
            small(ellipsize(m.optString("name", ""), mSmallFont, 21, 500 - ppw - 8 - 278), 278, y, WHITE);
            int pw = m.optInt("power", 0), acc = m.optInt("acc", 0);
            text("Pow " + (pw > 1 ? pw : "-") + "   Acc " + (acc > 0 ? acc : "-"), 280, y + 24, mSmallFont, 18, 0, DIM, SHADOW);
        }
    }

    // ---- Use item -------------------------------------------------------

    private void drawItems()
    {
        JSONObject p = selectedPokemon();
        box(6, 6, 500, 40);
        text("Use on " + (p != null ? p.optString("name", "") : "") + "?", 20, 12);
        JSONArray items = mState.optJSONArray("heal");
        int n = items == null ? 0 : items.length();
        float top = 54, rowH = 44;
        int perRow = 2;
        int rows = (n + perRow - 1) / perRow;
        listScroll(O_ITEMS, rows * rowH, 220);
        if (n == 0) small("You don't have any medicine.", W / 2f, 120, DIM, 2);
        mC.save();
        mC.clipRect(0, top, W, top + 220);
        for (int i = 0; i < n; i++) {
            JSONObject it = items.optJSONObject(i);
            float x = 6 + (i % perRow) * 252, y = top + (i / perRow) * rowH - mScroll[O_ITEMS];
            if (y + rowH < top || y > top + 220) continue;
            final String id = it.optString("id", "");
            box(x, y, 246, rowH - 4, 0xdc28203c);
            icon(it.optString("icon", ""), x + 22, y + 20, 36, false, null);
            small(ellipsize(it.optString("name", ""), mSmallFont, 21, 150), x + 44, y + 8, WHITE);
            small("x" + it.optInt("qty", 0), x + 238, y + 8, LILAC, 1);
            if (y >= top && y + rowH <= top + 220) {
                final int target = mSelected;
                hit(x, y, 246, rowH - 4, () -> {
                    command("cmd", "use_item", "item", id, "pkmn", String.valueOf(target));
                    mOverlay = O_SUMMARY;
                });
            }
        }
        mC.restore();
        button("BACK", 346, 282, 160, 44, true, false, () -> mOverlay = O_SUMMARY);
    }

    // ---- Journal --------------------------------------------------------

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
                blt("Graphics/Pictures/Location/icon_numbers", nx, 10, d * 14, 0, 14, 16, 14, 16, mBlit);
                nx += 14;
            }
        }
        text(loc != null ? loc.optString("name", "") : "", extended ? 73 : 59, -4, mFont, 27, 0, 0xffffffff, 0xff737373);

        // Story objective, paged like a message box
        box(8, 66, 340, 180);
        JSONObject q = mState.optJSONObject("quest");
        if (q != null) {
            text(ellipsize(q.optString("name", ""), mNarrowFont, 27, 320), 20, 72, mNarrowFont, 27, 0, GOLD, GOLD_SHADOW);
            String where = q.optString("location", "");
            if (!where.isEmpty()) small(where, 20, 100, LILAC);
            String desc = q.optString("desc", "");
            if (!desc.equals(mObjectiveText)) {
                mObjectiveText = desc;
                mObjectiveLines = wrap(desc, mSmallFont, 21, 300);
                mObjectivePage = 0;
                mObjectivePageAt = SystemClock.uptimeMillis();
            }
            int pages = Math.max(1, (mObjectiveLines.size() + 3) / 4);
            long now = SystemClock.uptimeMillis();
            if (pages > 1 && now - mObjectivePageAt > 7000) { mObjectivePage++; mObjectivePageAt = now; }
            mObjectivePage %= pages;
            int first = mObjectivePage * 4;
            for (int i = 0; i < 4 && first + i < mObjectiveLines.size(); i++) small(mObjectiveLines.get(first + i), 20, 126 + i * 23, WHITE);
            if (pages > 1 && (now / 400) % 2 == 0) arrow(326, 228);
            hit(8, 66, 340, 180, () -> { mObjectivePage++; mObjectivePageAt = SystemClock.uptimeMillis(); });
        } else {
            text("No active quest", 20, 72, mNarrowFont, 27, 0, GOLD, GOLD_SHADOW);
        }

        // Trainer
        box(356, 66, 148, 180);
        text(ellipsize(mState.optString("player", ""), mFont, 27, 128), 368, 72);
        small("$" + mb(mState.optLong("money", 0)), 368, 102, WHITE);
        long pt = mState.optLong("playtime", 0);
        small(String.format(Locale.US, "Play %d:%02d", pt / 3600, (pt / 60) % 60), 368, 126, WHITE);
        JSONObject clock = mState.optJSONObject("clock");
        if (clock != null) {
            text(clock.optString("time", ""), 368, 152, mFont, 27, 0, GOLD, GOLD_SHADOW);
            String tod = clock.optString("tod", "");
            int c = "Night".equals(tod) ? 0xff90a8f8 : "Evening".equals(tod) ? 0xffe8a060 : "Morning".equals(tod) ? 0xfff8e0a0 : 0xfff8f8a0;
            small(tod, 368, 180, c);
            small(clock.optString("season", ""), 368, 204, LILAC);
        }

        // Chapters
        box(8, 250, 380, 80);
        JSONArray badges = mState.optJSONArray("badges");
        for (int i = 0; i < 18; i++) {
            boolean got = badges != null && badges.optBoolean(i, false);
            int sx = (i % 9) * 32, sy = (i / 9) * 32;
            int bx = 18 + (i % 9) * 40, by = 256 + (i / 9) * 36;
            blt("Graphics/Pictures/Trainer Card/icon_badges", bx, by, sx, sy, 32, 32, 32, 32, got ? mBlit : mDark);
        }
        button("QUEST LOG", 394, 252, 112, 36, true, false, () -> { mOverlay = O_QUESTS; mScroll[O_QUESTS] = 0; });
        button("SCREEN OFF", 394, 292, 112, 36, true, false, () -> setScreenOn(false));
    }

    private void arrow(float x, float y)
    {
        Path a = new Path();
        a.moveTo(x, y); a.lineTo(x + 12, y); a.lineTo(x + 6, y + 8); a.close();
        mShape.setStyle(Paint.Style.FILL);
        mShape.setColor(WHITE);
        mC.drawPath(a, mShape);
    }

    private void drawQuestLog()
    {
        box(6, 6, 500, 40);
        text("Quest Log", 20, 12);
        JSONArray quests = mState.optJSONArray("quests");
        float top = 52, height = 274;
        List<Object[]> rows = new ArrayList<>();   // {lines, color, header?}
        for (int i = 0; quests != null && i < quests.length(); i++) {
            JSONObject q = quests.optJSONObject(i);
            if (q == null) continue;
            boolean done = q.optBoolean("done", false);
            String head = q.optString("name", "") + (done ? "  (done)" : q.optInt("stages", 0) > 0 ? "  " + q.optInt("stage") + "/" + q.optInt("stages") : "");
            rows.add(new Object[] { head, done ? DIM : GOLD, true });
            if (!done) {
                String where = q.optString("location", "");
                if (!where.isEmpty()) rows.add(new Object[] { where, LILAC, false });
                for (String l : wrap(q.optString("desc", ""), mSmallFont, 19, 470)) rows.add(new Object[] { l, WHITE, false });
            }
            rows.add(new Object[] { "", WHITE, false });
        }
        float lineH = 22;
        listScroll(O_QUESTS, rows.size() * lineH, height);
        box(6, top, 500, height);
        mC.save();
        mC.clipRect(8, top + 4, 504, top + height - 4);
        for (int i = 0; i < rows.size(); i++) {
            float y = top + 8 + i * lineH - mScroll[O_QUESTS];
            if (y < top - lineH || y > top + height) continue;
            Object[] r = rows.get(i);
            boolean head = (Boolean) r[2];
            text((String) r[0], 18, y, head ? mNarrowFont : mSmallFont, head ? 22 : 19, 0, (Integer) r[1], SHADOW);
        }
        mC.restore();
        if (rows.isEmpty()) small("No quests yet.", W / 2f, 120, DIM, 2);
        button("BACK", 418, 10, 84, 32, true, false, () -> mOverlay = O_NONE);
    }

    // ---- Map --------------------------------------------------------------

    private void drawMap()
    {
        blt("Graphics/Pictures/mapbg", 0, -24);
        JSONObject m = mState.optJSONObject("map");
        if (m == null) {
            box(W / 2f - 130, 150, 260, 40);
            small("No map for this area", W / 2f, 158, WHITE, 2);
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
        int px = ox - 8 + m.optInt("x") * 16, py = oy - 8 + m.optInt("y") * 16;
        int frame = (int) ((SystemClock.uptimeMillis() / 300) % 2);
        blt("Graphics/Pictures/mapCursor", px, py, frame * 32, 0, 32, 32, 32, 32, mBlit);
        blt(m.optString("player", ""), px, py);

        // Tap a location for its name (and Fly if allowed)
        final JSONArray points = m.optJSONArray("points");
        final int fox = ox, foy = oy;
        if (points != null) {
            hit(ox, oy, region != null ? region.getWidth() : 480, region != null ? region.getHeight() : 320, null);
            mHits.remove(mHits.size() - 1);
            mHits.add(new Hit(new RectF(ox, oy, ox + (region != null ? region.getWidth() : 480), oy + (region != null ? region.getHeight() : 320)),
                mHitSeq++, () -> {
                int best = -1;
                float bestD = 18 * 18;
                for (int i = 0; i < points.length(); i++) {
                    JSONArray pt = points.optJSONArray(i);
                    float cx = fox + pt.optInt(0) * 16 + 8, cy = foy + pt.optInt(1) * 16 + 8;
                    float d = (cx - mDownXv) * (cx - mDownXv) + (cy - mDownYv) * (cy - mDownYv);
                    if (d < bestD) { bestD = d; best = i; }
                }
                mMapPoint = best;
            }));
        }
        JSONArray pt = (points != null && mMapPoint >= 0 && mMapPoint < points.length()) ? points.optJSONArray(mMapPoint) : null;
        if (pt != null) {
            int cx = ox + pt.optInt(0) * 16, cy = oy + pt.optInt(1) * 16;
            mShape.setStyle(Paint.Style.STROKE);
            mShape.setStrokeWidth(2);
            mShape.setColor(GOLD);
            mC.drawRect(cx, cy, cx + 16, cy + 16, mShape);
        }
        label(m.optString("region", ""), 24, 14, GOLD, false);
        String here = pt != null ? pt.optString(2, "") : (mState.optJSONObject("location") != null ? mState.optJSONObject("location").optString("name", "") : "");
        label(here, 24, 292, WHITE, false);
        if (pt != null && pt.optBoolean(3, false) && m.optBoolean("can_fly", false)) {
            final int fx = pt.optInt(0), fy = pt.optInt(1);
            button("FLY", 406, 286, 90, 36, free(), false, () -> command("cmd", "fly", "x", String.valueOf(fx), "y", String.valueOf(fy)));
        }
    }

    private float mDownXv, mDownYv;   // last touch-down position in page coordinates

    private void label(String s, float x, float y, int color, boolean alignRight)
    {
        if (s == null || s.isEmpty()) return;
        float w = measure(s, mSmallFont, 21) + 16;
        if (alignRight) x -= w;
        box(x, y, w, 30, 0xd2181428);
        small(s, x + 8, y + 3, color);
    }

    // ---- Route encounters ---------------------------------------------

    private void drawRoute()
    {
        box(6, 6, 500, 40);
        JSONObject loc = mState.optJSONObject("location");
        text(loc != null ? loc.optString("name", "") : "", 20, 12);
        JSONArray groups = mState.optJSONArray("route");
        float top = 52, height = 276;
        List<Object> rows = new ArrayList<>();   // String header or JSONObject entry
        for (int g = 0; groups != null && g < groups.length(); g++) {
            JSONObject grp = groups.optJSONObject(g);
            rows.add(grp.optString("type", ""));
            JSONArray entries = grp.optJSONArray("entries");
            for (int i = 0; entries != null && i < entries.length(); i++) rows.add(entries.optJSONObject(i));
        }
        float rowH = 34;
        listScroll(P_ROUTE, rows.size() * rowH, height);
        box(6, top, 500, height);
        mC.save();
        mC.clipRect(8, top + 4, 504, top + height - 4);
        for (int i = 0; i < rows.size(); i++) {
            float y = top + 6 + i * rowH - mScroll[P_ROUTE];
            if (y < top - rowH || y > top + height) continue;
            Object r = rows.get(i);
            if (r instanceof String) {
                text((String) r, 18, y + 4, mNarrowFont, 24, 0, GOLD, GOLD_SHADOW);
                continue;
            }
            JSONObject e = (JSONObject) r;
            boolean seen = e.optBoolean("seen", false);
            icon(e.optString("icon", ""), 40, y + 16, 48, seen, seen ? null : mDark);
            small(e.optString("name", "???"), 74, y + 4, seen ? WHITE : DIM);
            small("Lv." + e.optString("lv", ""), 300, y + 4, LILAC);
            small(e.optInt("pct", 0) + "%", 400, y + 4, WHITE, 1);
            if (e.optBoolean("owned", false)) blt("Graphics/Pictures/Pokedex/icon_own", 448, y + 2);
        }
        mC.restore();
        if (rows.isEmpty()) small("No wild Pokémon here.", W / 2f, 140, DIM, 2);
    }

    // ---- Text history -----------------------------------------------------

    private void drawLog()
    {
        box(6, 6, 500, 40);
        text("Recent text", 20, 12);
        JSONArray log = mState.optJSONArray("log");
        List<Object[]> lines = new ArrayList<>();
        for (int i = 0; log != null && i < log.length(); i++) {
            String s = log.optString(i, "");
            int colon = s.indexOf(": ");
            String speaker = colon > 0 && colon < 24 ? s.substring(0, colon) : null;
            List<String> w = wrap(speaker != null ? s.substring(colon + 2) : s, mSmallFont, 20, 470);
            if (speaker != null) lines.add(new Object[] { speaker, GOLD });
            for (String l : w) lines.add(new Object[] { l, WHITE });
            lines.add(new Object[] { "", WHITE });
        }
        float top = 52, height = 276, lineH = 22;
        float content = lines.size() * lineH;
        // Newest text at the bottom; scroll 0 = bottom
        listScroll(P_LOG, content, height);
        box(6, top, 500, height);
        mC.save();
        mC.clipRect(8, top + 4, 504, top + height - 4);
        float start = top + height - 8 - content + mScroll[P_LOG];
        for (int i = 0; i < lines.size(); i++) {
            float y = start + i * lineH;
            if (y < top - lineH || y > top + height) continue;
            Object[] l = lines.get(i);
            text((String) l[0], 18, y, mSmallFont, 20, 0, (Integer) l[1], SHADOW);
        }
        mC.restore();
        if (lines.isEmpty()) small("Dialogue will show up here.", W / 2f, 140, DIM, 2);
    }

    // ---- More / quick actions ----------------------------------------

    private void drawMore()
    {
        boolean can = free();
        box(6, 6, 500, 40);
        text("Quick actions", 20, 12);
        int speed = mState.optInt("speed", 1);
        button("MENU", 10, 54, 160, 48, can, false, () -> command("cmd", "menu"));
        button("SAVE", 176, 54, 160, 48, can, false, () -> command("cmd", "save"));
        button("SPEED x" + speed, 342, 54, 160, 48, true, false, () -> command("cmd", "speed"));

        JSONObject quick = mState.optJSONObject("quick");
        JSONObject repel = quick != null ? quick.optJSONObject("repel") : null;
        String repelLabel = repel != null ? repel.optString("name", "Repel") + " x" + repel.optInt("qty") : "NO REPEL";
        button(repelLabel, 10, 108, 244, 48, can && repel != null, false, () -> command("cmd", "repel"));
        int steps = (repel != null) ? repel.optInt("steps", 0) : 0;
        if (steps > 0) {
            box(260, 112, 246, 40);
            small(steps + " steps left", 272, 120, LILAC);
        }

        JSONArray reg = quick != null ? quick.optJSONArray("registered") : null;
        box(6, 164, 500, 108);
        small("Registered items", 16, 168, GOLD);
        int n = reg == null ? 0 : reg.length();
        for (int i = 0; i < Math.min(n, 4); i++) {
            JSONObject it = reg.optJSONObject(i);
            final String id = it.optString("id", "");
            float x = 12 + i * 124, y = 196;
            button("", x, y, 118, 70, can, false, () -> command("cmd", "key_item", "item", id));
            icon(it.optString("icon", ""), x + 59, y + 21, 36, false, null);
            text(ellipsize(it.optString("name", ""), mSmallFont, 17, 108), x + 59, y + 42, mSmallFont, 17, 2, can ? WHITE : DIM, SHADOW);
        }
        if (n == 0) {
            small("Register key items (like the Bicycle)", 16, 204, DIM);
            small("in the Bag to use them from here.", 16, 230, DIM);
        }
        if (!can) {
            box(6, 280, 330, 46);
            text("Available while you're free to move.", 18, 294, mSmallFont, 17, 0, DIM, SHADOW);
        }
        button("SCREEN OFF", 342, 280, 160, 46, true, false, () -> setScreenOn(false));
    }

    // ---- Battle -------------------------------------------------------------

    private void drawBattle()
    {
        JSONObject b = mState.optJSONObject("battle");
        JSONArray foes = b.optJSONArray("foes"), allies = b.optJSONArray("allies");
        // Foes (top) and your Pokémon (below)
        int nf = foes == null ? 0 : foes.length();
        for (int i = 0; i < nf; i++) battler(foes.optJSONObject(i), 6 + i * (500 / Math.max(1, nf)) , 6, 500 / Math.max(1, nf) - 4, true);
        int na = allies == null ? 0 : allies.length();
        for (int i = 0; i < na; i++) battler(allies.optJSONObject(i), 6 + i * (500 / Math.max(1, na)), 86, 500 / Math.max(1, na) - 4, false);

        String menu = b.optString("menu", "none");
        float top = 166;
        if ("command".equals(menu)) {
            JSONArray cmds = b.optJSONArray("commands");
            String prompt = b.optString("prompt", "");
            if (!prompt.isEmpty()) small(ellipsize(prompt, mSmallFont, 21, 490), W / 2f, top - 2, LILAC, 2);
            for (int i = 0; i < 4; i++) {
                String label = cmds != null && i < cmds.length() ? cmds.optString(i, "") : "";
                if (label.isEmpty()) continue;
                final int idx = i;
                button(label.toUpperCase(Locale.ROOT), 6 + (i % 2) * 252, top + 24 + (i / 2) * 72, 246, 66, true, false,
                    () -> command("cmd", "battle_command", "index", String.valueOf(idx)));
            }
        } else if ("fight".equals(menu)) {
            JSONArray moves = b.optJSONArray("moves");
            for (int i = 0; i < 4; i++) {
                JSONObject m = moves != null && i < moves.length() ? moves.optJSONObject(i) : null;
                float x = 6 + (i % 2) * 252, y = top + (i / 2) * 64;
                if (m == null) { box(x, y, 246, 58, 0xb0181428); continue; }
                final int idx = i;
                boolean hasPP = m.optInt("pp", 0) > 0;
                button("", x, y, 246, 58, true, false, () -> command("cmd", "battle_move", "index", String.valueOf(idx)));
                typeIcon(m.optJSONObject("type"), x + 8, y + 6, 56);
                small(ellipsize(m.optString("name", ""), mSmallFont, 21, 170), x + 70, y + 4, hasPP ? WHITE : RED);
                text("PP " + m.optInt("pp") + "/" + m.optInt("maxpp"), x + 70, y + 30, mSmallFont, 18, 0, LILAC, SHADOW);
                JSONArray eff = m.optJSONArray("eff");
                String e = eff != null && eff.length() > 0 ? eff.optString(0, "") : "";
                String et = "super".equals(e) ? "Super eff." : "weak".equals(e) ? "Not very eff." : "none".equals(e) ? "No effect" : "";
                int ec = "super".equals(e) ? GREEN : "none".equals(e) ? RED : 0xfff0c060;
                if (!et.isEmpty()) text(et, x + 238, y + 31, mSmallFont, 16, 1, ec, SHADOW);
                categoryIcon(m.optInt("cat", 2), x + 8, y + 34, 40);
            }
            float by = top + 130;
            button("BACK", 6, by, 120, 34, true, false, () -> command("cmd", "battle_back"));
            if (b.optBoolean("can_special", false))
                button("MEGA / SPECIAL", 132, by, 200, 34, true, false, () -> command("cmd", "battle_special"));
            if (b.optBoolean("can_shift", false))
                button("SHIFT", 338, by, 120, 34, true, false, () -> command("cmd", "battle_shift"));
        } else {
            box(6, top, 500, 158);
            small("...", W / 2f, top + 64, LILAC, 2);
        }
    }

    private void battler(JSONObject o, float x, float y, float w, boolean foe)
    {
        if (o == null) return;
        box(x, y, w, 74, foe ? 0xdc3a1c28 : 0xdc1c2a3a);
        icon(o.optString("icon", ""), x + 32, y + 34, 56, !o.optBoolean("fainted", false), null);
        small(ellipsize(o.optString("name", ""), mSmallFont, 21, w - 130), x + 64, y + 6, WHITE);
        small("Lv." + o.optInt("lv", 1), x + w - 10, y + 6, LILAC, 1);
        float frac = foe ? (float) o.optDouble("hp_frac", 0) : o.optInt("hp", 0) / (float) Math.max(1, o.optInt("maxhp", 1));
        hpBar(x + 64, y + 34, w - 76, frac);
        if (!foe) text(o.optInt("hp") + "/" + o.optInt("maxhp"), x + w - 10, y + 44, mSmallFont, 17, 1, WHITE, SHADOW);
        int status = o.optInt("status", -1);
        if (status >= 0) blt("Graphics/Pictures/statuses", (int) x + 64, (int) y + 48, 0, status * 16, 44, 16, 44, 16, mBlit);
        JSONArray types = o.optJSONArray("types");
        for (int i = 0; types != null && i < types.length() && foe; i++) typeIcon(types.optJSONObject(i), x + 112 + i * 46, y + 50, 42);
        JSONObject stages = o.optJSONObject("stages");
        if (stages != null && stages.length() > 0) {
            StringBuilder sb = new StringBuilder();
            java.util.Iterator<String> it = stages.keys();
            while (it.hasNext()) {
                String k = it.next();
                int v = stages.optInt(k);
                sb.append(shortStat(k)).append(v > 0 ? "+" : "").append(v).append(' ');
            }
            text(sb.toString().trim(), x + w - 10, y + 54, mSmallFont, 15, 1, v(sb) ? GOLD : GOLD, SHADOW);
        }
    }

    private static boolean v(StringBuilder sb) { return sb.length() > 0; }

    private static String shortStat(String k)
    {
        switch (k) {
            case "ATTACK": return "Atk";
            case "DEFENSE": return "Def";
            case "SPECIAL_ATTACK": return "SpA";
            case "SPECIAL_DEFENSE": return "SpD";
            case "SPEED": return "Spe";
            case "ACCURACY": return "Acc";
            case "EVASION": return "Eva";
            default: return k.length() > 3 ? k.substring(0, 3) : k;
        }
    }

    // ---- Keyboard (naming screens) -------------------------------------

    private static final String[] KB_ROWS = { "1234567890", "QWERTYUIOP", "ASDFGHJKL'", "ZXCVBNM,.-" };

    private void drawKeyboard()
    {
        JSONObject e = mState.optJSONObject("entry");
        String typed = e.optString("text", "");
        int max = e.optInt("max", 0);
        box(6, 6, 500, 48);
        text(typed + ((SystemClock.uptimeMillis() / 500) % 2 == 0 ? "_" : " "), 20, 14);
        if (max > 0) small(typed.length() + "/" + max, 494, 18, LILAC, 1);
        float kw = 48, kh = 48, gap = 3;
        for (int r = 0; r < KB_ROWS.length; r++) {
            String row = KB_ROWS[r];
            float x0 = 6 + (500 - row.length() * (kw + gap) + gap) / 2f;
            for (int c = 0; c < row.length(); c++) {
                char ch = row.charAt(c);
                final String out = Character.isLetter(ch) ? (mShift ? String.valueOf(ch) : String.valueOf(Character.toLowerCase(ch))) : String.valueOf(ch);
                button(out, x0 + c * (kw + gap), 62 + r * (kh + gap), kw, kh, true, false, () -> {
                    command("cmd", "type", "text", out);
                    if (mShift && Character.isLetter(out.charAt(0))) mShift = false;
                });
            }
        }
        float y = 62 + 4 * (kh + gap);
        button(mShift ? "abc" : "ABC", 6, y, 90, 54, true, mShift, () -> mShift = !mShift);
        button("SPACE", 100, y, 200, 54, true, false, () -> command("cmd", "type", "text", " "));
        button("DEL", 304, y, 90, 54, true, false, () -> command("cmd", "backspace"));
        button("OK", 398, y, 108, 54, typed.length() >= e.optInt("min", 1), false, () -> command("cmd", "enter"));
    }

    // =====================================================================
    // Input
    // =====================================================================

    private void listScroll(int key, float content, float view)
    {
        mScrollKey = key;
        mScrollMax = (int) Math.max(0, content - view);
        mScroll[key] = Math.max(0, Math.min(mScrollMax, mScroll[key]));
    }

    private void setScreenOn(boolean on)
    {
        mScreenOn = on;
        mPrefs.edit().putBoolean("panel_on", on).apply();
        Log.i(TAG, "Second screen " + (on ? "on" : "off"));
        invalidate();
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
        switch (e.getActionMasked()) {
            case MotionEvent.ACTION_DOWN:
                mDownX = vx; mDownY = vy; mLastY = vy;
                mDownXv = vx; mDownYv = vy;
                mDragging = false;
                mPressed = -1;
                for (int i = mHits.size() - 1; i >= 0; i--) {
                    if (mHits.get(i).r.contains(vx, vy)) { mPressed = mHits.get(i).id; break; }
                }
                return true;
            case MotionEvent.ACTION_MOVE:
                if (Math.abs(vy - mDownY) > 10 || Math.abs(vx - mDownX) > 10) mDragging = true;
                if (mDragging && mScrollKey >= 0 && vy < BAR_Y) {
                    int dir = mScrollKey == P_LOG ? 1 : -1;
                    mScroll[mScrollKey] = Math.max(0, Math.min(mScrollMax, mScroll[mScrollKey] + (int) (dir * (vy - mLastY))));
                    mPressed = -1;
                }
                mLastY = vy;
                return true;
            case MotionEvent.ACTION_UP:
                int pressed = mPressed;
                mPressed = -1;
                if (!mDragging || pressed >= 0) {
                    for (int i = mHits.size() - 1; i >= 0; i--) {
                        Hit h = mHits.get(i);
                        if (h.r.contains(vx, vy)) {
                            if (h.id == pressed || pressed < 0) {
                                if (h.action != null) h.action.run();
                            }
                            break;
                        }
                    }
                }
                invalidate();
                return true;
            case MotionEvent.ACTION_CANCEL:
                mPressed = -1;
                return true;
        }
        return true;
    }
}
