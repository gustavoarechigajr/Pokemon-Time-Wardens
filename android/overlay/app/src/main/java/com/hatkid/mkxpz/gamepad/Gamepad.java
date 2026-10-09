package com.hatkid.mkxpz.gamepad;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.ViewGroup;
import android.view.LayoutInflater;
import android.view.InputDevice;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.animation.AlphaAnimation;
import android.util.Log;
import android.widget.RelativeLayout;

import com.hatkid.mkxpz.R;
import com.hatkid.mkxpz.utils.ViewUtils;

public class Gamepad
{
    private GamepadConfig mGamepadConfig = null;
    private boolean mInvisible = false;

    private OnKeyDownListener mOnKeyDownListener = key -> {};
    private OnKeyUpListener mOnKeyUpListener = key -> {};

    public interface OnKeyDownListener
    {
        void onKeyDown(int key);
    }

    public interface OnKeyUpListener
    {
        void onKeyUp(int key);
    }

    public void setOnKeyDownListener(OnKeyDownListener onKeyDownListener)
    {
        mOnKeyDownListener = onKeyDownListener;
    }

    public void setOnKeyUpListener(OnKeyUpListener onKeyUpListener)
    {
        mOnKeyUpListener = onKeyUpListener;
    }

    private RelativeLayout mGamepadLayout;

    // Gamepad buttons
    private GamepadButton gpadBtnA;
    private GamepadButton gpadBtnB;
    private GamepadButton gpadBtnC;
    private GamepadButton gpadBtnX;
    private GamepadButton gpadBtnY;
    private GamepadButton gpadBtnZ;
    private GamepadButton gpadBtnL;
    private GamepadButton gpadBtnR;
    private GamepadButton gpadBtnCTRL;
    private GamepadButton gpadBtnALT;
    private GamepadButton gpadBtnSHIFT;

    public void init(GamepadConfig gpadConfig, boolean invisible)
    {
        mGamepadConfig = gpadConfig;
        mInvisible = invisible;
    }

    @SuppressLint("ClickableViewAccessibility")
    public void attachTo(Context context, ViewGroup viewGroup)
    {
        // Setup layout of in-screen gamepad
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        ViewGroup layout = (ViewGroup) inflater.inflate(R.layout.gamepad_layout, viewGroup);
        mGamepadLayout = layout.findViewById(R.id.gamepad_layout);

        if (mInvisible) {
            mGamepadLayout.setAlpha(0);
        }

        // Setup D-Pad and buttons
        GamepadDPad gpadDPad = layout.findViewById(R.id.dpad);
        gpadBtnA = layout.findViewById(R.id.button_A);
        gpadBtnB = layout.findViewById(R.id.button_B);
        gpadBtnC = layout.findViewById(R.id.button_C);
        gpadBtnX = layout.findViewById(R.id.button_X);
        gpadBtnY = layout.findViewById(R.id.button_Y);
        gpadBtnZ = layout.findViewById(R.id.button_Z);
        gpadBtnL = layout.findViewById(R.id.button_L);
        gpadBtnR = layout.findViewById(R.id.button_R);
        gpadBtnCTRL = layout.findViewById(R.id.button_CTRL);
        gpadBtnALT = layout.findViewById(R.id.button_ALT);
        gpadBtnSHIFT = layout.findViewById(R.id.button_SHIFT);

        // Setup in-screen gamepad listeners
        mGamepadLayout.setOnTouchListener((view, motionEvent) -> false);
        gpadDPad.setOnKeyDownListener(key -> mOnKeyDownListener.onKeyDown(key));
        gpadDPad.setOnKeyUpListener(key -> mOnKeyUpListener.onKeyUp(key));

        // Configure gamepad
        gpadDPad.isDiagonal = mGamepadConfig.diagonalMovement;

        // Setup buttons for gamepad
        initGamepadButtons();

        // Apply scale and opacity from gamepad config
        ViewUtils.resize(mGamepadLayout, mGamepadConfig.scale);
        ViewUtils.changeOpacity(mGamepadLayout, mGamepadConfig.opacity);
    }

    private static String labelForKey(int keycode)
    {
        switch (keycode)
        {
            case KeyEvent.KEYCODE_C: return "OK";
            case KeyEvent.KEYCODE_X: return "Back";
            case KeyEvent.KEYCODE_Z: return "Act";
            case KeyEvent.KEYCODE_A: return "X";
            case KeyEvent.KEYCODE_S: return "Y";
            case KeyEvent.KEYCODE_D: return "Z";
            case KeyEvent.KEYCODE_Q: return "Fast";
            case KeyEvent.KEYCODE_W: return "Slow";
            default:
                return KeyEvent.keyCodeToString(keycode)
                    .replace("KEYCODE_", "")
                    .replace("_LEFT", "")
                    .replace("_RIGHT", "");
        }
    }

    private void setGamepadButtonKey(GamepadButton gpadBtn, Integer keycode)
    {
        // Prepare label for gamepad button (Time Wardens: name buttons after
        // the Pokemon Essentials action they trigger instead of the raw key)
        String btnLabel = labelForKey(keycode);

        // Set gamepad button
        gpadBtn.setForegroundText(btnLabel);
        gpadBtn.setKey(keycode);
        gpadBtn.setOnKeyDownListener(key -> mOnKeyDownListener.onKeyDown(key));
        gpadBtn.setOnKeyUpListener(key -> mOnKeyUpListener.onKeyUp(key));
    }

    public void showView()
    {
        if (mGamepadLayout != null) {
            if (mGamepadLayout.getAlpha() == 0)
                mGamepadLayout.setAlpha(1);

            AlphaAnimation anim = new AlphaAnimation(0.0f, 1.0f);
            anim.setDuration(250);
            anim.setFillAfter(true);
            mGamepadLayout.startAnimation(anim);
        }
    }

    public void hideView()
    {
        if (mGamepadLayout != null) {
            AlphaAnimation anim = new AlphaAnimation(1.0f, 0.0f);
            anim.setDuration(500);
            anim.setFillAfter(true);
            mGamepadLayout.startAnimation(anim);
        }
    }

    private void initGamepadButtons()
    {
        setGamepadButtonKey(gpadBtnA, mGamepadConfig.keycodeA);
        setGamepadButtonKey(gpadBtnB, mGamepadConfig.keycodeB);
        setGamepadButtonKey(gpadBtnC, mGamepadConfig.keycodeC);
        setGamepadButtonKey(gpadBtnX, mGamepadConfig.keycodeX);
        setGamepadButtonKey(gpadBtnY, mGamepadConfig.keycodeY);
        setGamepadButtonKey(gpadBtnZ, mGamepadConfig.keycodeZ);
        setGamepadButtonKey(gpadBtnL, mGamepadConfig.keycodeL);
        setGamepadButtonKey(gpadBtnR, mGamepadConfig.keycodeR);
        setGamepadButtonKey(gpadBtnCTRL, mGamepadConfig.keycodeCTRL);
        setGamepadButtonKey(gpadBtnALT, mGamepadConfig.keycodeALT);
        setGamepadButtonKey(gpadBtnSHIFT, mGamepadConfig.keycodeSHIFT);
    }

    /**
     * Maps a physical controller button to the keyboard key the game is
     * bound to (mkxp-z default RGSS bindings), or 0 if it is not mapped.
     *
     * Layout follows Android's positional button codes, as used by handhelds
     * such as the AYN Thor and by Xbox-style pads:
     *   A (bottom) = OK, B (right) = Back/menu, X (left) = Action,
     *   Y (top) = Special, L1/R1 = speed up/down, L2/R2 = jump up/down in
     *   lists, Start = menu, Select = Special.
     */
    public static int mapControllerKey(int keycode)
    {
        switch (keycode)
        {
            case KeyEvent.KEYCODE_BUTTON_A:
            case KeyEvent.KEYCODE_DPAD_CENTER:
                return KeyEvent.KEYCODE_C;
            case KeyEvent.KEYCODE_BUTTON_B:
            case KeyEvent.KEYCODE_BUTTON_START:
                return KeyEvent.KEYCODE_X;
            case KeyEvent.KEYCODE_BUTTON_X:
                return KeyEvent.KEYCODE_Z;
            case KeyEvent.KEYCODE_BUTTON_Y:
            case KeyEvent.KEYCODE_BUTTON_SELECT:
                return KeyEvent.KEYCODE_D;
            case KeyEvent.KEYCODE_BUTTON_L1:
                return KeyEvent.KEYCODE_Q;
            case KeyEvent.KEYCODE_BUTTON_R1:
                return KeyEvent.KEYCODE_W;
            case KeyEvent.KEYCODE_BUTTON_L2:
                return KeyEvent.KEYCODE_A;
            case KeyEvent.KEYCODE_BUTTON_R2:
                return KeyEvent.KEYCODE_S;
            case KeyEvent.KEYCODE_DPAD_UP:
            case KeyEvent.KEYCODE_DPAD_DOWN:
            case KeyEvent.KEYCODE_DPAD_LEFT:
            case KeyEvent.KEYCODE_DPAD_RIGHT:
                return keycode;
            default:
                return 0;
        }
    }

    /** True if any connected input device is a game controller. */
    public static boolean hasController()
    {
        for (int id : InputDevice.getDeviceIds()) {
            InputDevice dev = InputDevice.getDevice(id);
            if (dev == null || dev.isVirtual()) continue;
            int src = dev.getSources();
            if ((src & InputDevice.SOURCE_GAMEPAD) == InputDevice.SOURCE_GAMEPAD
                || (src & InputDevice.SOURCE_JOYSTICK) == InputDevice.SOURCE_JOYSTICK)
                return true;
        }
        return false;
    }

    private static boolean isFromController(KeyEvent evt)
    {
        int src = evt.getSource();
        return (src & InputDevice.SOURCE_GAMEPAD) == InputDevice.SOURCE_GAMEPAD
            || (src & InputDevice.SOURCE_JOYSTICK) == InputDevice.SOURCE_JOYSTICK
            || (src & InputDevice.SOURCE_DPAD) == InputDevice.SOURCE_DPAD;
    }

    /**
     * Handles controller buttons. Gamepad buttons (BUTTON_*) are always
     * translated; D-pad keys only when they come from a controller, so
     * keyboard arrow keys keep going straight to SDL.
     */
    public boolean processGamepadEvent(KeyEvent evt)
    {
        int keycode = evt.getKeyCode();
        boolean gamepadButton = KeyEvent.isGamepadButton(keycode) || keycode == KeyEvent.KEYCODE_DPAD_CENTER;

        if (!gamepadButton && !isFromController(evt))
            return false;

        int mapped = mapControllerKey(keycode);
        if (mapped == 0)
            return gamepadButton; // swallow unmapped pad buttons (e.g. stick clicks)

        switch (evt.getAction())
        {
            case KeyEvent.ACTION_DOWN:
                if (evt.getRepeatCount() == 0) {
                    Log.d("TimeWardens[Pad]", KeyEvent.keyCodeToString(keycode) + " -> " + KeyEvent.keyCodeToString(mapped));
                    mOnKeyDownListener.onKeyDown(mapped);
                }
                break;

            case KeyEvent.ACTION_UP:
                mOnKeyUpListener.onKeyUp(mapped);
                break;
        }

        return true;
    }

    // Direction keys currently held because of the hat / analog stick
    private boolean mUp, mDown, mLeft, mRight;
    private static final float STICK_THRESHOLD = 0.5f;

    private void setDirection(boolean now, boolean before, int keycode)
    {
        if (now && !before) mOnKeyDownListener.onKeyDown(keycode);
        else if (!now && before) mOnKeyUpListener.onKeyUp(keycode);
    }

    /**
     * Handles the D-pad (reported as a hat) and the left analog stick, which
     * arrive as continuous motion events, by turning them into arrow key
     * presses and releases.
     */
    public boolean processDPadEvent(MotionEvent evt)
    {
        int src = evt.getSource();
        if ((src & InputDevice.SOURCE_JOYSTICK) != InputDevice.SOURCE_JOYSTICK
            && (src & InputDevice.SOURCE_GAMEPAD) != InputDevice.SOURCE_GAMEPAD
            && (src & InputDevice.SOURCE_DPAD) != InputDevice.SOURCE_DPAD)
            return false;

        if (evt.getActionMasked() != MotionEvent.ACTION_MOVE)
            return false;

        float hatX = evt.getAxisValue(MotionEvent.AXIS_HAT_X);
        float hatY = evt.getAxisValue(MotionEvent.AXIS_HAT_Y);
        float x = evt.getAxisValue(MotionEvent.AXIS_X);
        float y = evt.getAxisValue(MotionEvent.AXIS_Y);

        // Ignore the stick's dead zone as reported by the device
        InputDevice dev = evt.getDevice();
        if (dev != null) {
            InputDevice.MotionRange rx = dev.getMotionRange(MotionEvent.AXIS_X, src);
            InputDevice.MotionRange ry = dev.getMotionRange(MotionEvent.AXIS_Y, src);
            if (rx != null && Math.abs(x) <= rx.getFlat()) x = 0;
            if (ry != null && Math.abs(y) <= ry.getFlat()) y = 0;
        }

        boolean up = hatY < -0.5f || y < -STICK_THRESHOLD;
        boolean down = hatY > 0.5f || y > STICK_THRESHOLD;
        boolean left = hatX < -0.5f || x < -STICK_THRESHOLD;
        boolean right = hatX > 0.5f || x > STICK_THRESHOLD;

        // Grid movement: keep only the dominant stick axis on diagonals
        if ((up || down) && (left || right) && hatX == 0 && hatY == 0) {
            if (Math.abs(x) > Math.abs(y)) { up = false; down = false; }
            else { left = false; right = false; }
        }

        setDirection(up, mUp, KeyEvent.KEYCODE_DPAD_UP);
        setDirection(down, mDown, KeyEvent.KEYCODE_DPAD_DOWN);
        setDirection(left, mLeft, KeyEvent.KEYCODE_DPAD_LEFT);
        setDirection(right, mRight, KeyEvent.KEYCODE_DPAD_RIGHT);
        mUp = up; mDown = down; mLeft = left; mRight = right;

        return true;
    }
}
