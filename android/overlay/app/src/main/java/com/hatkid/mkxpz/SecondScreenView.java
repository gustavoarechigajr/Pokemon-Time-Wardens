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
    // Battle message box text (Battle::Scene::MESSAGE_BASE_COLOR / SHADOW)
    static final int MSG_BASE = 0xff505058, MSG_SHADOW = 0xffa0a0a8;
    // The game draws text this far above the y it is given (text_offset_y)
    static final int GAME_Y = 8;

    private final File mGameDir;
    private final File mIpcDir;
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
    private boolean mMoveInfo;                // move details shown in the fight menu
    private int mInfoSel;                     // move whose details are shown
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
            if (now - mLastPoll >= 250) {   // fallback; changes normally arrive via mObserver
                mLastPoll = now;
                poll();
            }
            invalidate();
            mHandler.postDelayed(this, mScreenOn ? 33 : 500);
        }
    };

    public SecondScreenView(Context ctx, File gameDir, File ipcDir, File statusFile, String demo)
    {
        super(ctx);
        mGameDir = gameDir;
        mIpcDir = ipcDir;
        mStatusFile = statusFile;
        mDemo = demo != null;
        mPrefs = ctx.getSharedPreferences("dualscreen", Context.MODE_PRIVATE);
        mPage = Math.max(0, Math.min(TABS.length - 1, mPrefs.getInt("page2", P_PARTY)));
        mScreenOn = mPrefs.getBoolean("panel_on", true);
        mMoveInfo = mPrefs.getBoolean("move_info", false);
        mBagTab = Math.max(0, Math.min(2, mPrefs.getInt("bag_tab", 0)));
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
                case "info":
                    mState.put("battle", mState.optJSONObject("battle_fight"));
                    mBattlePage = true;
                    mMoveInfo = true;
                    mInfoSel = 1;
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

    // ---- Sounds: the game's own menu sound effects -----------------------

    private android.media.SoundPool mSounds;
    private int mSndDecision, mSndCancel;
    private boolean mSoundCancel;   // set by an action: play the cancel sound
    private boolean mSoundSkip;     // set by an action: the game plays its own sound

    private void loadSounds()
    {
        try {
            mSounds = new android.media.SoundPool.Builder().setMaxStreams(3)
                .setAudioAttributes(new android.media.AudioAttributes.Builder()
                    .setUsage(android.media.AudioAttributes.USAGE_GAME)
                    .setContentType(android.media.AudioAttributes.CONTENT_TYPE_SONIFICATION).build())
                .build();
            mSndDecision = loadSound("Audio/SE/GUI sel decision.ogg");
            mSndCancel = loadSound("Audio/SE/GUI sel cancel.ogg");
        } catch (RuntimeException e) {
            Log.w(TAG, "Sounds: " + e);
            mSounds = null;
        }
    }

    private int loadSound(String rel)
    {
        File f = resolve(rel);
        return (f != null && mSounds != null) ? mSounds.load(f.getAbsolutePath(), 1) : 0;
    }

    private void playSound(int id)
    {
        if (mSounds == null || id == 0) return;
        // Follows the game's sound-effect volume option
        float vol = 0.8f * (mState != null ? mState.optInt("se_volume", 100) : 100) / 100f;
        mSounds.play(id, vol, vol, 1, 0, 1f);
    }

    // The game renames its new status file into place: react at once
    // instead of waiting for the next poll
    private final Runnable mStatusChanged = () -> { poll(true); invalidate(); };
    private android.os.FileObserver mObserver;

    @Override protected void onAttachedToWindow()
    {
        super.onAttachedToWindow();
        mHandler.post(mTick);
        if (mSounds == null) loadSounds();
        if (!mDemo) {
            final String name = mStatusFile.getName();
            mObserver = new android.os.FileObserver(mIpcDir.getPath(),
                android.os.FileObserver.MOVED_TO | android.os.FileObserver.CLOSE_WRITE) {
                @Override public void onEvent(int event, String path) {
                    if (name.equals(path)) mHandler.post(mStatusChanged);
                }
            };
            mObserver.startWatching();
        }
    }

    @Override protected void onDetachedFromWindow()
    {
        mHandler.removeCallbacks(mTick);
        if (mObserver != null) mObserver.stopWatching();
        mObserver = null;
        if (mSounds != null) mSounds.release();
        mSounds = null;
        super.onDetachedFromWindow();
    }

    // =====================================================================
    // Data in / commands out
    // =====================================================================

    private void poll() { poll(false); }

    private void poll(boolean force)
    {
        if (mDemo) return;
        long mod = mStatusFile.lastModified();
        if (mod == 0 || (mod == mLastModified && !force)) return;
        mLastModified = mod;
        try (FileInputStream in = new FileInputStream(mStatusFile)) {
            byte[] data = new byte[(int) Math.min(mStatusFile.length(), 4 << 20)];
            int n = 0, r;
            while (n < data.length && (r = in.read(data, n, data.length - n)) > 0) n += r;
            JSONObject prev = mState;
            mState = new JSONObject(new String(data, 0, n, StandardCharsets.UTF_8));
            // The game moved on from the menu that was tapped: controls are live again
            if (mPendingUntil > 0 && !battleSig().equals(mPendingSig)) mPendingUntil = 0;
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
        File tmp = new File(mIpcDir, name + ".tmp");
        try (FileOutputStream os = new FileOutputStream(tmp)) {
            os.write(sb.toString().getBytes(StandardCharsets.UTF_8));
        } catch (Exception e) {
            Log.w(TAG, "Command write failed: " + e);
            return;
        }
        if (!tmp.renameTo(new File(mIpcDir, name))) tmp.delete();
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
        String[] candidates = rel.toLowerCase(Locale.ROOT).matches(".*\\.(png|ttf|ogg)$")
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
        text(label, x + w / 2f, capTop(tf, size, y + h / 2f), tf, size, 2, enabled ? WHITE : DIM, SHADOW);
        if (enabled && action != null) mHits.add(new Hit(new RectF(x, y, x + w, y + h), id, action));
    }

    private final Rect mBounds = new Rect();

    /**
     * The y to give text() so capital letters are centred on cy. The game's
     * fonts have a lot of space above the letters, so centring the whole
     * line box puts text visibly low. (-1: half of the 2px shadow.)
     */
    private float capTop(Typeface tf, float size, float cy)
    {
        mText.setTypeface(tf);
        mText.setTextSize(size);
        mText.getTextBounds("H", 0, 1, mBounds);
        float baseline = cy - mBounds.top / 2f;
        return baseline + mText.ascent() - 1;
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
        mC.drawBitmap(sky(), 0, 0, mBlit);
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
    private Bitmap mSky;

    /**
     * The party background's night sky without its panel frames (they would
     * show through on other pages): same colours, stars and big sparkle.
     */
    private Bitmap sky()
    {
        if (mSky != null) return mSky;
        mSky = Bitmap.createBitmap(W, H, Bitmap.Config.ARGB_8888);
        Canvas c = new Canvas(mSky);
        c.drawColor(0xff110e1e);
        Paint p = new Paint();
        java.util.Random rnd = new java.util.Random(20);
        int[] colors = { 0xff5a566c, 0xff888595, 0xffbcbbc4 };
        for (int i = 0; i < 110; i++) {
            int x = rnd.nextInt(W / 2) * 2, y = rnd.nextInt(H / 2) * 2;
            p.setColor(colors[rnd.nextInt(10) < 6 ? 0 : rnd.nextInt(10) < 7 ? 1 : 2]);
            c.drawRect(x, y, x + 2, y + 2, p);
            if (rnd.nextInt(14) == 0) {   // small twinkle
                p.setColor(colors[1]);
                c.drawRect(x - 2, y, x, y + 2, p); c.drawRect(x + 2, y, x + 4, y + 2, p);
                c.drawRect(x, y - 2, x + 2, y, p); c.drawRect(x, y + 2, x + 2, y + 4, p);
            }
        }
        Bitmap bg = image("Graphics/Pictures/Party/bg");
        if (bg != null) {
            // The big sparkle below the panels
            Rect src = new Rect(168, 292, 244, 372);
            c.drawBitmap(bg, src, src, mBlit);
        }
        return mSky;
    }

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
        blt("Graphics/Pictures/Party/bg", 0, 0);
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
            text(ellipsize(pname, nameFont, 27, 126), x + 96, y + 22 - GAME_Y, nameFont, 27, 0, WHITE, SHADOW);

            if (!egg) {
                blt("Graphics/Pictures/Party/overlay_hp_back" + (fainted ? "_faint" : ""), x + 96, y + 50);
                blt("Graphics/Pictures/Party/overlay_lv", x + 20, y + 70);
                text(String.valueOf(p.optInt("lv", 1)), x + 42, y + 68 - GAME_Y, mSmallFont, 21, 0, WHITE, SHADOW);
                int gender = p.optInt("gender", 2);
                if (gender == 0) text("♂", x + 224, y + 22 - GAME_Y, mFont, 27, 0, 0xff0070f8, 0xff78b8e8);
                else if (gender == 1) text("♀", x + 224, y + 22 - GAME_Y, mFont, 27, 0, 0xffe82010, 0xfff8a8b8);
                int hp = p.optInt("hp", 0), max = Math.max(1, p.optInt("maxhp", 1));
                String key = p.optString("name", "") + "/" + max;
                if (!key.equals(mShownKey[i])) { mShownKey[i] = key; mShownHp[i] = hp; }
                float diff = hp - mShownHp[i];
                mShownHp[i] += Math.signum(diff) * Math.min(Math.abs(diff), Math.max(0.5f, max / 40f));
                int shown = Math.round(mShownHp[i]);
                text(String.format(Locale.US, "%3d /%3d", shown, max), x + 224, y + 66 - GAME_Y, mFont, 27, 1, WHITE, SHADOW);
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
            text("Items and swapping work while you're free to move.", W / 2f, capTop(mSmallFont, 17, 311), mSmallFont, 17, 2, DIM, SHADOW);
        }
    }

    private void drawSummaryInfo(JSONObject p)
    {
        float y = 48;
        small("Species", 210, y, DIM); small(p.optString("species", ""), 330, y, WHITE); y += 24;
        small("Type", 210, y, DIM);
        JSONArray types = p.optJSONArray("types");
        for (int i = 0; types != null && i < types.length(); i++) typeIcon(types.optJSONObject(i), 330 + i * 70, y + 1, 64);
        y += 28;
        small("Nature", 210, y, DIM); small(p.optString("nature", ""), 330, y, WHITE); y += 24;
        small("Item", 210, y, DIM);
        small(p.optString("item_name", "").isEmpty() ? "None" : p.optString("item_name", ""), 330, y, WHITE); y += 24;
        small("Ability", 210, y, DIM); small(p.optString("ability", ""), 330, y, GOLD); y += 22;
        // Ability description: two lines at most, so it never runs into Exp.
        List<String> lines = wrap(p.optString("ability_desc", ""), mSmallFont, 17, 284);
        for (int i = 0; i < Math.min(2, lines.size()); i++) {
            String line = lines.get(i);
            if (i == 1 && lines.size() > 2) line = ellipsize(line + " ...", mSmallFont, 17, 284);
            text(line, 210, y + i * 18, mSmallFont, 17, 0, LILAC, SHADOW);
        }
        y = 216;
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
        text("Use on " + (p != null ? p.optString("name", "") : "") + "?", 20, capTop(mFont, 27, 26), mFont, 27, 0, WHITE, SHADOW);
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
        text("Quest Log", 20, capTop(mFont, 27, 26), mFont, 27, 0, WHITE, SHADOW);
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
        text(loc != null ? loc.optString("name", "") : "", 20, capTop(mFont, 27, 26), mFont, 27, 0, WHITE, SHADOW);
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
        text("Recent text", 20, capTop(mFont, 27, 26), mFont, 27, 0, WHITE, SHADOW);
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
        text("Quick actions", 20, capTop(mFont, 27, 26), mFont, 27, 0, WHITE, SHADOW);
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
        small("Registered items", 16, 170, GOLD);
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
            text("Available while you're free to move.", 18, capTop(mSmallFont, 17, 303), mSmallFont, 17, 0, DIM, SHADOW);
        }
        button("SCREEN OFF", 342, 280, 160, 46, true, false, () -> setScreenOn(false));
    }

    // ---- Battle -------------------------------------------------------------

    // Modelled on the DS games' touch screen (Diamond/Pearl, HeartGold/SoulSilver,
    // Black/White): one big FIGHT button with BAG, RUN and POKEMON below it, and
    // move buttons that show name, type and PP. As on the 3DS (Sun/Moon), each
    // move also says how effective it is. The battle itself, its text and the
    // Pokemon's HP stay on the top screen.
    private void drawBattle()
    {
        JSONObject b = mState.optJSONObject("battle");
        String menu = b.optString("menu", "none");
        drawEmblem();
        int hits = mHits.size();
        if (!"command".equals(menu)) mBattleSub = SUB_NONE;
        if ("command".equals(menu) && mBattleSub == SUB_SWITCH) drawBattleParty(b, false);
        else if ("command".equals(menu) && mBattleSub == SUB_ITEM_TARGET) drawBattleParty(b, true);
        else if ("command".equals(menu) && mBattleSub == SUB_BAG) drawBattleBag(b);
        else if ("command".equals(menu)) drawBattleCommands(b);
        else if ("fight".equals(menu)) drawBattleFight(b);
        if (SystemClock.uptimeMillis() < mPendingUntil) {
            fillRect(0, 0, W, BAR_Y - 2, 0x70000000);
            while (mHits.size() > hits) mHits.remove(mHits.size() - 1);
        }
    }

    // Graphics rows used for Fight/Bag/Pokemon/Run in each command menu mode
    // (Battle::Scene::CommandMenu::MODES in the game's scripts)
    private static final int[][] CMD_MODES = { {0, 2, 1, 3}, {0, 2, 1, 9}, {0, 2, 1, 4}, {5, 7, 6, 3}, {0, 8, 1, 3} };
    private static final int CMD_W = 130, CMD_H = 46, FIGHT_W = 192;

    /** A faint, slowly pulsing Poke Ball behind the battle controls. */
    private void drawEmblem()
    {
        float cx = W / 2f, cy = 166, r = 140;
        double t = SystemClock.uptimeMillis() / 1600.0;
        int a = 16 + (int) (6 * Math.sin(t));
        mShape.setStyle(Paint.Style.STROKE);
        mShape.setStrokeWidth(12);
        mShape.setColor(a << 24 | 0xffffff);
        mC.drawCircle(cx, cy, r, mShape);
        mC.drawCircle(cx, cy, 36, mShape);
        mShape.setStyle(Paint.Style.FILL);
        mC.drawRect(cx - r, cy - 6, cx - 42, cy + 6, mShape);
        mC.drawRect(cx + 42, cy - 6, cx + r, cy + 6, mShape);
    }

    /** One of the game's battle button graphics (unselected and selected columns), scaled. */
    private void artButton(String rel, int colW, int row, int h, float x, float y, float scale, boolean selected, Runnable action)
    {
        int id = mHitSeq++;
        boolean pressed = mPressed == id;
        int dw = Math.round(colW * scale), dh = Math.round(h * scale);
        blt(rel, (int) x, (int) y, (pressed || selected) ? colW : 0, row * h, colW, h, dw, dh, mBlit);
        if (action != null) mHits.add(new Hit(new RectF(x, y, x + dw, y + dh), id, action));
    }

    private void drawBattleCommands(JSONObject b)
    {
        int mode = Math.max(0, Math.min(CMD_MODES.length - 1, b.optInt("cmd_mode", 0)));
        String cmd = "Graphics/Pictures/Battle/cursor_command";
        // FIGHT large in the middle; Bag, Run and Pokemon along the bottom
        artButton(cmd, CMD_W, CMD_MODES[mode][0], CMD_H, (W - CMD_W * 2) / 2f, 52, 2f, false, () -> battleCommand(0));
        // Bag and Pokemon open on this screen when the game sent the lists
        // (TOP SCREEN there opens the game's own menu instead)
        final boolean hasItems = b.has("items"), hasParty = b.has("party");
        artButton(cmd, CMD_W, CMD_MODES[mode][1], CMD_H, 10, 214, 1.25f, false,
            () -> { if (hasItems && mode <= 2) mBattleSub = SUB_BAG; else battleCommand(1); });
        artButton(cmd, CMD_W, CMD_MODES[mode][3], CMD_H, (W - CMD_W) / 2f, 220, 1f, false, () -> battleCommand(3));
        artButton(cmd, CMD_W, CMD_MODES[mode][2], CMD_H, W - 10 - Math.round(CMD_W * 1.25f), 214, 1.25f, false,
            () -> { if (hasParty) mBattleSub = SUB_SWITCH; else battleCommand(2); });
    }

    private void battleCommand(int idx)
    {
        sendBattle("cmd", "battle_command", "index", String.valueOf(idx));
    }

    // The game's PP colours: none left, 1/4 or less, 1/2 or less, more
    private static final int[] PP_BASE = { 0xfff84848, 0xfff88820, 0xfff8c000, MSG_BASE };
    private static final int[] PP_SHADOW = { 0xff883030, 0xff904818, 0xff906800, MSG_SHADOW };

    private void drawBattleFight(JSONObject b)
    {
        JSONArray moves = b.optJSONArray("moves");
        int n = moves == null ? 0 : moves.length();
        if (mInfoSel >= n) mInfoSel = 0;
        // Move info (toggle): shorter buttons and a details panel; a first tap
        // picks a move to read about, a second tap on it uses it
        boolean info = mMoveInfo;
        int bw = 240, bh = info ? 72 : 96, gap = info ? 6 : 10;
        float top = info ? 6 : 12;
        for (int i = 0; i < 4; i++) {
            JSONObject m = i < n ? moves.optJSONObject(i) : null;
            float x = (i % 2 == 0) ? W / 2f - gap / 2f - bw : W / 2f + gap / 2f;
            float y = top + (i / 2) * (bh + gap);
            if (m == null) continue;
            final int idx = i;
            boolean sel = info && i == mInfoSel;
            moveButton(m, x, y, bw, bh, info, sel, () -> {
                if (mMoveInfo && mInfoSel != idx) { mInfoSel = idx; return; }
                sendBattle("cmd", "battle_move", "index", String.valueOf(idx));
            });
        }
        float panelTop = top + 2 * (bh + gap);
        if (info && n > 0) drawMoveDetails(moves.optJSONObject(mInfoSel), 6, panelTop, W - 12, 284 - panelTop - 4);

        // One row below: special action, cancel, shift and the info toggle
        boolean special = b.optBoolean("can_special", false), shift = b.optBoolean("can_shift", false);
        int count = 2 + (special ? 1 : 0) + (shift ? 1 : 0);
        float cgap = 8, ch = 46, by = info ? 284 : top + 2 * (bh + gap) + 6;
        float cw = Math.min(150, (W - 16 - (count - 1) * cgap) / count);
        float cx = (W - (count * cw + (count - 1) * cgap)) / 2f;
        if (special) {
            boolean on = b.optBoolean("special_on", false);
            capsule("ACTION", cx, by, cw, ch, on, true, () -> sendBattle("cmd", "battle_special"));
            cx += cw + cgap;
        }
        capsule("CANCEL", cx, by, cw, ch, false, false, () -> sendBattle("cmd", "battle_back"));
        cx += cw + cgap;
        if (shift) {
            capsule("SHIFT", cx, by, cw, ch, false, false, () -> sendBattle("cmd", "battle_shift"));
            cx += cw + cgap;
        }
        capsule("INFO", cx, by, cw, ch, info, false, () -> {
            mMoveInfo = !mMoveInfo;
            mPrefs.edit().putBoolean("move_info", mMoveInfo).apply();
        });
    }

    /** A move button: name in its type colour; type, physical/special/status and PP below. */
    private void moveButton(JSONObject m, float x, float y, float bw, float bh, boolean compact, boolean sel, Runnable action)
    {
        Bitmap art = image("Graphics/Pictures/Battle/cursor_fight");
        JSONObject type = m.optJSONObject("type");
        int row = type != null ? type.optInt("icon", 0) : 0;
        int id = mHitSeq++;
        moveButtonArt(art, row, sel || mPressed == id, x, y, bw, bh);
        mHits.add(new Hit(new RectF(x, y, x + bw, y + bh), id, action));
        // Name in the button's own colour, as the game does
        int base = MSG_BASE;
        if (art != null && row * CMD_H + 34 < art.getHeight()) base = art.getPixel(10, row * CMD_H + 34) | 0xff000000;
        String name = m.optString("name", "");
        Typeface nf = measure(name, mFont, 27) > bw - 40 ? mNarrowFont : mFont;
        text(ellipsize(name, nf, 27, bw - 40), x + bw / 2f, y + (compact ? 5 : 8), nf, 27, 2, base, MSG_SHADOW);
        float ly = y + (compact ? 38 : 42);
        typeIcon(type, x + 22, ly, compact ? 48 : 56);
        categoryIcon(m.optInt("cat", 2), x + (compact ? 74 : 84), ly + 1, compact ? 44 : 48);
        int pp = m.optInt("pp", 0), max = Math.max(1, m.optInt("maxpp", 1));
        int frac = pp == 0 ? 0 : Math.min(3, (int) Math.ceil(4.0 * pp / max));
        text("PP " + pp + "/" + max, x + bw - 22, ly - 4, mSmallFont, 18, 1, PP_BASE[frac], PP_SHADOW[frac]);
        if (compact) return;
        // As on the 3DS: how well it works against the opponent
        JSONArray eff = m.optJSONArray("eff");
        String e = eff != null && eff.length() > 0 ? eff.optString(0, "") : "";
        String et = effText(e);
        if (!et.isEmpty()) text(et, x + bw / 2f, y + 60, mSmallFont, 18, 2, effColor(e), MSG_SHADOW);
    }

    private static String effText(String e)
    {
        return "super".equals(e) ? "Super effective" : "weak".equals(e) ? "Not very effective"
            : "none".equals(e) ? "No effect" : "normal".equals(e) ? "Effective" : "";
    }

    private static int effColor(String e)
    {
        return "super".equals(e) ? 0xff208830 : "weak".equals(e) ? 0xffc06010 : "none".equals(e) ? 0xffb02828 : MSG_BASE;
    }

    private static final String[] CATEGORY = { "Physical", "Special", "Status" };

    /** Details of one move: power, accuracy, effect chance, priority and what it does. */
    private void drawMoveDetails(JSONObject m, float x, float y, float w, float h)
    {
        if (m == null) return;
        blt9("Graphics/Pictures/Battle/overlay_message", x, y, w, h);
        float tx = x + 18, ty = y + 8;
        int cat = Math.max(0, Math.min(2, m.optInt("cat", 2)));
        float nw = text(m.optString("name", ""), tx, ty, mFont, 27, 0, MSG_BASE, MSG_SHADOW);
        typeIcon(m.optJSONObject("type"), tx + nw + 12, ty + 4, 56);
        categoryIcon(cat, tx + nw + 72, ty + 5, 48);
        JSONArray eff = m.optJSONArray("eff");
        String e = eff != null && eff.length() > 0 ? eff.optString(0, "") : "";
        if (!effText(e).isEmpty()) text(effText(e), x + w - 18, ty + 4, mSmallFont, 18, 1, effColor(e), MSG_SHADOW);
        StringBuilder sb = new StringBuilder();
        int pw = m.optInt("power", 0), acc = m.optInt("acc", 0), chance = m.optInt("chance", 0), pri = m.optInt("priority", 0);
        sb.append(CATEGORY[cat]);
        if (cat != 2) sb.append("   Power ").append(pw > 1 ? String.valueOf(pw) : "-");
        sb.append("   Accuracy ").append(acc > 0 ? acc + "%" : "-");
        if (chance > 0 && chance < 100) sb.append("   Effect ").append(chance).append('%');
        if (pri != 0) sb.append("   Priority ").append(pri > 0 ? "+" : "").append(pri);
        text(sb.toString(), tx, ty + 28, mSmallFont, 18, 0, 0xff304878, 0xffa8b8d0);
        List<String> lines = wrap(m.optString("desc", ""), mSmallFont, 17, w - 36);
        int maxLines = Math.max(1, (int) ((h - 58) / 18));
        for (int i = 0; i < Math.min(maxLines, lines.size()); i++) {
            String line = lines.get(i);
            if (i == maxLines - 1 && lines.size() > maxLines) line = ellipsize(line + " ...", mSmallFont, 17, w - 36);
            text(line, tx, ty + 50 + i * 18, mSmallFont, 17, 0, MSG_BASE, MSG_SHADOW);
        }
    }

    /** Stretches a framed graphic (the message box) to any size, keeping its 12px border. */
    private void blt9(String rel, float x, float y, float w, float h)
    {
        Bitmap b = image(rel);
        if (b == null) { box(x, y, w, h); return; }
        int bw = b.getWidth(), bh = b.getHeight(), e = 12;
        int[] sx = { 0, e, bw - e, bw };
        int[] sy = { 0, e, bh - e, bh };
        float[] dx = { x, x + e, x + w - e, x + w };
        float[] dy = { y, y + e, y + h - e, y + h };
        for (int i = 0; i < 3; i++)
            for (int j = 0; j < 3; j++)
                mC.drawBitmap(b, new Rect(sx[i], sy[j], sx[i + 1], sy[j + 1]), new RectF(dx[i], dy[j], dx[i + 1], dy[j + 1]), mBlit);
    }

    // Battle choices give instant feedback: the controls dim until the game
    // has acted on the tap (or a moment has passed), and can't be tapped twice
    private long mPendingUntil;
    private String mPendingSig = "";

    private String battleSig()
    {
        JSONObject b = mState != null ? mState.optJSONObject("battle") : null;
        return b == null ? "" : b.optString("menu", "") + "/" + b.optInt("battler", -1) + "/" + b.optBoolean("special_on", false);
    }

    private void sendBattle(String... kv)
    {
        command(kv);
        mSoundSkip = true;   // the game plays its own sound when it acts on it
        mPendingSig = battleSig();
        mPendingUntil = SystemClock.uptimeMillis() + 1200;
    }

    /**
     * A move button from cursor_fight.png, widened 1.25x and made taller by
     * stretching the beige band, so it fits two lines like the DS buttons.
     */
    private void moveButtonArt(Bitmap art, int row, boolean pressed, float x, float y, float w, float h)
    {
        if (art == null) { box(x, y, w, h); return; }
        int sx = pressed ? FIGHT_W : 0, sy = row * CMD_H;
        float top = 24 * 1.25f, bottom = 10 * 1.25f;
        mC.drawBitmap(art, new Rect(sx, sy, sx + FIGHT_W, sy + 24), new RectF(x, y, x + w, y + top), mBlit);
        mC.drawBitmap(art, new Rect(sx, sy + 24, sx + FIGHT_W, sy + 36), new RectF(x, y + top, x + w, y + h - bottom), mBlit);
        mC.drawBitmap(art, new Rect(sx, sy + 36, sx + FIGHT_W, sy + 46), new RectF(x, y + h - bottom, x + w, y + h), mBlit);
    }

    /**
     * A button drawn in the style of the game's battle buttons (dark outline,
     * white rim, night-blue fill; reddish when switched on), so buttons the
     * game has no graphic for match the ones it has.
     */
    private void capsule(String label, float x, float y, float w, float h, boolean on, boolean icon, Runnable action)
    {
        int id = mHitSeq++;
        boolean pressed = mPressed == id;
        Paint p = new Paint();   // no anti-aliasing: crisp like the pixel art
        float r = h / 2f;
        p.setColor(0xff303030);
        mC.drawRoundRect(new RectF(x, y, x + w, y + h), r, r, p);
        p.setColor(0xfff8f8f8);
        mC.drawRoundRect(new RectF(x + 4, y + 4, x + w - 4, y + h - 4), r - 4, r - 4, p);
        int top = on ? 0xff4a1428 : pressed ? 0xff3c4a8c : 0xff1a224c;
        int bot = on ? 0xff2c0e1c : pressed ? 0xff2c2a5c : 0xff241a33;
        RectF in = new RectF(x + 6, y + 6, x + w - 6, y + h - 6);
        p.setColor(bot);
        mC.drawRoundRect(in, r - 6, r - 6, p);
        mC.save();
        mC.clipRect(in.left, in.top, in.right, in.centerY());
        p.setColor(top);
        mC.drawRoundRect(in, r - 6, r - 6, p);
        mC.restore();
        p.setColor(0xfff8f8f8);   // two little stars, as on the game's buttons
        mC.drawRect(x + 14, y + 10, x + 16, y + 12, p);
        mC.drawRect(x + w - 18, y + h - 14, x + w - 16, y + h - 12, p);
        float tx = x + w / 2f;
        if (icon) {
            // The special-action orb from cursor_mega.png
            blt("Graphics/Pictures/Battle/cursor_mega", (int) (x + 12), (int) (y + 8), 14, on ? 56 : 10, 34, 34, 30, 30, mBlit);
            tx += 16;
        }
        float room = w - 24 - (icon ? 34 : 0);
        Typeface tf = measure(label, mFont, 27) > room ? mNarrowFont : mFont;
        float size = 27;
        while (size > 18 && measure(label, tf, size) > room) size -= 1;
        text(label, tx, capTop(tf, size, y + h / 2f), tf, size, 2, 0xfff8f0e0, 0xff404040);
        final boolean cancel = "BACK".equals(label) || "CANCEL".equals(label);
        if (action != null) mHits.add(new Hit(new RectF(x, y, x + w, y + h), id,
            cancel ? () -> { mSoundCancel = true; action.run(); } : action));
    }

    // ---- Battle: Pokemon and Bag on the touch screen --------------------

    static final int SUB_NONE = 0, SUB_SWITCH = 1, SUB_BAG = 2, SUB_ITEM_TARGET = 3;
    static final int SCROLL_BAG = 6;
    private int mBattleSub = SUB_NONE;
    private String mSubItem = "", mSubItemName = "";
    private int mBagTab = 0;   // 0 = balls, 1 = medicine, 2 = battle items
    private static final String[] BAG_TABS = { "BALLS", "MEDICINE", "BATTLE" };

    /** Title strip for the battle sub-pages, in the battle message box style. */
    private void battleTitle(String title)
    {
        box(6, 4, W - 12, 40);
        Typeface tf = measure(title, mFont, 27) > W - 44 ? mNarrowFont : mFont;
        text(ellipsize(title, tf, 27, W - 44), 20, capTop(tf, 27, 24), tf, 27, 0, WHITE, SHADOW);
    }

    /** Back to the commands, or open the game's own menu on the top screen. */
    private void subPageButtons(int topCommand)
    {
        float by = 286, cw = 180;
        capsule("BACK", W / 2f - cw - 6, by, cw, 46, false, false, () -> { mBattleSub = SUB_NONE; mSoundCancel = true; });
        capsule("TOP SCREEN", W / 2f + 6, by, cw, 46, false, false, () -> { mBattleSub = SUB_NONE; battleCommand(topCommand); });
    }

    private void drawBattleParty(JSONObject b, boolean forItem)
    {
        battleTitle(forItem ? "Use " + mSubItemName + " on which Pokémon?" : "Switch to which Pokémon?");
        JSONArray party = b.optJSONArray("party");
        int n = party == null ? 0 : Math.min(6, party.length());
        float cw = 248, ch = 74;
        for (int i = 0; i < n; i++) {
            JSONObject p = party.optJSONObject(i);
            if (p == null) continue;
            float x = (i % 2 == 0) ? 6 : W - 6 - cw, y = 50 + (i / 2) * (ch + 4);
            boolean egg = p.optBoolean("egg", false), fainted = p.optBoolean("fainted", false);
            boolean active = p.optBoolean("active", false);
            boolean can = !egg && (forItem || (!fainted && !active));
            final int idx = p.optInt("index", i);
            int id = mHitSeq++;
            boolean pressed = can && mPressed == id;
            box(x, y, cw, ch, pressed ? 0xf04a3c78 : can ? 0xe8261e40 : 0xc0181428);
            if (can) mHits.add(new Hit(new RectF(x, y, x + cw, y + ch), id, () -> {
                if (forItem) sendBattle("cmd", "battle_item", "item", mSubItem, "index", String.valueOf(idx));
                else sendBattle("cmd", "battle_switch", "index", String.valueOf(idx));
            }));
            icon(p.optString("icon", ""), x + 36, y + 38, 64, can && !fainted, fainted ? mDark : null);
            String pname = p.optString("name", "");
            Typeface nf = measure(pname, mSmallFont, 21) > 110 ? mNarrowFont : mSmallFont;
            text(ellipsize(pname, nf, 21, 116), x + 72, y + 6, nf, 21, 0, can ? WHITE : DIM, SHADOW);
            if (egg) continue;
            text("Lv." + p.optInt("lv", 1), x + cw - 10, y + 6, mSmallFont, 18, 1, LILAC, SHADOW);
            int hp = p.optInt("hp", 0), max = Math.max(1, p.optInt("maxhp", 1));
            // HP bar with the numbers beside it; status and matchup on the line below
            float hpw = measure(hp + "/" + max, mSmallFont, 17);
            hpBar(x + 72, y + 32, cw - 90 - hpw, hp / (float) max);
            text(hp + "/" + max, x + cw - 10, y + 24, mSmallFont, 17, 1, WHITE, SHADOW);
            int status = p.optInt("status", -1);
            float tx = x + 72;
            if (status >= 0) {
                blt("Graphics/Pictures/statuses", (int) tx, (int) y + 46, 0, status * 16, 44, 16, 44, 16, mBlit);
                tx += 50;
            }
            // How it matches up against the foe (like the 3DS games)
            if (active) {
                text("In battle", tx, y + 42, mSmallFont, 17, 0, GOLD, GOLD_SHADOW);
            } else if (!fainted && !forItem) {
                String off = p.optString("offense", ""), def = p.optString("defense", "");
                String tag = null; int col = DIM;
                if ("super".equals(def)) { tag = "Weak to foe"; col = 0xfff07060; }
                else if ("super".equals(off)) { tag = "Hits foe hard"; col = 0xff70e070; }
                else if ("weak".equals(def) || "none".equals(def)) { tag = "Resists foe"; col = 0xff88c8f8; }
                if (tag != null) text(tag, tx, y + 42, mSmallFont, 17, 0, col, SHADOW);
            }
        }
        subPageButtons(forItem ? 1 : 2);
    }

    private boolean inBagTab(JSONObject it, int tab)
    {
        int use = it.optInt("use", 0);
        boolean ball = it.optBoolean("ball", false) || use == 4;
        if (tab == 0) return ball;
        if (tab == 1) return !ball && (use == 1 || use == 2);
        return !ball && (use == 3 || use == 5);
    }

    private void drawBattleBag(JSONObject b)
    {
        JSONArray items = b.optJSONArray("items");
        float tw = 160, tgap = 8, tx0 = (W - (3 * tw + 2 * tgap)) / 2f;
        for (int t = 0; t < 3; t++) {
            final int tab = t;
            capsule(BAG_TABS[t], tx0 + t * (tw + tgap), 4, tw, 46, mBagTab == t, false, () -> {
                mBagTab = tab;
                mScroll[SCROLL_BAG] = 0;
                mPrefs.edit().putInt("bag_tab", tab).apply();
            });
        }
        List<JSONObject> list = new ArrayList<>();
        for (int i = 0; items != null && i < items.length(); i++) {
            JSONObject it = items.optJSONObject(i);
            if (it != null && inBagTab(it, mBagTab)) list.add(it);
        }
        float top = 58, view = 222, cw = 248, ch = 50, gap = 4;
        int rows = (list.size() + 1) / 2;
        listScroll(SCROLL_BAG, rows * (ch + gap), view);
        if (list.isEmpty()) small(mBagTab == 0 ? "No Poké Balls." : "Nothing here to use in battle.", W / 2f, 150, DIM, 2);
        mC.save();
        mC.clipRect(0, top, W, top + view);
        for (int i = 0; i < list.size(); i++) {
            JSONObject it = list.get(i);
            float x = (i % 2 == 0) ? 6 : W - 6 - cw, y = top + (i / 2) * (ch + gap) - mScroll[SCROLL_BAG];
            if (y + ch < top || y > top + view) continue;
            final String id = it.optString("id", ""), name = it.optString("name", "");
            final int use = it.optInt("use", 0);
            int hid = mHitSeq++;
            box(x, y, cw, ch, mPressed == hid ? 0xf04a3c78 : 0xe8261e40);
            if (y >= top && y + ch <= top + view) mHits.add(new Hit(new RectF(x, y, x + cw, y + ch), hid, () -> {
                if (use == 1) {               // on a Pokemon: pick which one here
                    mSubItem = id; mSubItemName = name; mBattleSub = SUB_ITEM_TARGET;
                } else if (use == 2) {        // on a move (Ethers): the game's own menu
                    mBattleSub = SUB_NONE; battleCommand(1);
                } else {
                    sendBattle("cmd", "battle_item", "item", id);
                }
            }));
            icon(it.optString("icon", ""), x + 26, y + ch / 2f, 40, false, null);
            text(ellipsize(name, mSmallFont, 21, cw - 110), x + 52, capTop(mSmallFont, 21, y + ch / 2f), mSmallFont, 21, 0, WHITE, SHADOW);
            text("x" + it.optInt("qty", 0), x + cw - 12, capTop(mSmallFont, 21, y + ch / 2f), mSmallFont, 21, 1, LILAC, SHADOW);
        }
        mC.restore();
        subPageButtons(1);
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
                if (mPressed >= 0) {
                    // Immediate feedback: pressed graphic now, and a light tick
                    performHapticFeedback(android.view.HapticFeedbackConstants.KEYBOARD_TAP);
                    invalidate();
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
                                if (h.action != null) {
                                    mSoundCancel = mSoundSkip = false;
                                    h.action.run();
                                    if (!mSoundSkip) playSound(mSoundCancel ? mSndCancel : mSndDecision);
                                }
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
