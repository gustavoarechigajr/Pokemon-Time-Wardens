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
 * screen, the second display shows SecondScreenView - a touch companion
 * screen (party, journal, map, route, battle controls, keyboard...). The
 * game feeds it through Mods/Android_DualScreen.rb, which writes
 * .tw_status.json while the ".tw_dualscreen" flag file exists, and reads
 * the .tw_cmd_*.txt command files the view writes back.
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

    private final boolean mDemo;

    public DualScreen(Activity activity, File gameDir, boolean demo)
    {
        mDemo = demo;
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
            setContentView(new SecondScreenView(getContext(), mGameDir, mStatusFile, mDemo));
        }
    }
}
