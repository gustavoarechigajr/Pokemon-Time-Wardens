#!/usr/bin/env bash
# Smoke test for the Time Wardens APK on a running emulator (used by CI).
#
# Installs the APK, starts the game, waits for the first-launch unpacking,
# then drives the title screen and reports:
#   * engine/Ruby errors and native crashes from logcat
#   * small screenshots, printed base64-encoded between markers so they can
#     be recovered from the job log:  ==SHOT <name>== <base64 jpeg>
#
#   emulator_test.sh <apk>
set -uo pipefail

APK="$1"
PKG="${TW_PACKAGE:-com.gustavoarechigajr.timewardens}"
OUT="${RUNNER_TEMP:-/tmp}/emu"
mkdir -p "$OUT"
FAIL=0

log() { echo "[$(date +%H:%M:%S)] $*"; }

shot() {
  local name="$1"
  adb exec-out screencap -p > "$OUT/$name.png" 2>/dev/null || return 0
  if command -v convert >/dev/null; then
    convert "$OUT/$name.png" -resize 640x -quality 70 "$OUT/$name.jpg" 2>/dev/null || return 0
    echo "==SHOT $name== $(base64 -w0 "$OUT/$name.jpg")"
  fi
}

key() { adb shell input keyevent "$@"; }

check_alive() {
  if ! adb shell pidof "$PKG" >/dev/null 2>&1; then
    log "!! game process is not running"
    return 1
  fi
}

adb logcat -c
adb logcat -v time > "$OUT/logcat.txt" 2>&1 &
LOGCAT_PID=$!

log "Installing $(du -h "$APK" | cut -f1) APK"
adb install -r "$APK" || { log "!! install failed"; exit 1; }
adb shell dumpsys package "$PKG" | grep -E "versionName|versionCode" | head -2

log "Launching"
adb shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 > /dev/null
sleep 15
shot installing

# Wait for first-launch unpacking (logcat: "Game installed to")
for i in $(seq 1 120); do
  if grep -q "Game installed to" "$OUT/logcat.txt"; then
    log "Game files unpacked after ~$((15 + i * 5))s"
    break
  fi
  if grep -q "Game install failed" "$OUT/logcat.txt"; then
    log "!! unpack failed"; FAIL=1; break
  fi
  sleep 5
done
grep -q "Game installed to" "$OUT/logcat.txt" || { log "!! game files were not unpacked"; FAIL=1; }

adb shell ls -la "/sdcard/Android/data/$PKG/files/game" 2>&1 | head -30

# Let the engine boot (splash screens) and take screenshots along the way
for t in 10 20 30 45; do
  sleep 10
  shot "boot_${t}"
  check_alive || FAIL=1
done

# Inputs below go through the controller path (as on handhelds like the
# AYN Thor): "input gamepad"/"input dpad" inject events with a gamepad/D-pad
# source, which MainActivity maps to the game's keys.
pad() { adb shell input gamepad keyevent "$@"; }
dpad() { adb shell input dpad keyevent "$@"; }

# Title screen -> continue/new game menu -> new game, pressing A (= OK)
for step in 1 2 3 4 5 6; do
  pad KEYCODE_BUTTON_A
  sleep 6
  shot "pad_a_${step}"
  check_alive || { FAIL=1; break; }
done

# Advance intro dialogue with A
for step in 1 2 3 4 5 6 7 8 9 10; do
  pad KEYCODE_BUTTON_A
  sleep 3
done
shot "after_dialogue"

# D-pad movement from a controller
dpad KEYCODE_DPAD_DOWN KEYCODE_DPAD_DOWN KEYCODE_DPAD_LEFT KEYCODE_DPAD_RIGHT
sleep 3
shot "after_walk"

# B opens the pause menu, B again closes it
pad KEYCODE_BUTTON_B; sleep 4; shot "pad_b_menu"
pad KEYCODE_BUTTON_B; sleep 3; shot "pad_b_closed"

# Keyboard still works (C = OK) and the phone's back key acts as Back
key KEYCODE_BACK; sleep 4; shot "back_key_menu"
key KEYCODE_BACK; sleep 3
check_alive || { log "!! back key closed the game"; FAIL=1; }

# Dual screen: attach a simulated second display (like the AYN Thor's
# bottom screen) while the game runs; the info panel should appear on it and
# the game should start writing its status file.
log "Attaching simulated second display"
adb shell settings put global overlay_display_devices 960x540/240
sleep 8
pad KEYCODE_BUTTON_A; sleep 4
shot "dual_screen"
adb shell dumpsys display | grep -E "mDisplayId=|mName=|Overlay" | head -10
if grep -q "Second screen found" "$OUT/logcat.txt"; then
  log "Dual screen panel opened"
else
  log "!! dual screen panel did not open"; FAIL=1
fi
echo "---- status file ----"
adb shell cat "/sdcard/Android/data/$PKG/files/game/.tw_status.json" 2>&1 | head -c 2000; echo
adb shell settings put global overlay_display_devices null
sleep 3
check_alive || { log "!! game died when the second display was removed"; FAIL=1; }

sleep 2
kill "$LOGCAT_PID" 2>/dev/null

echo "================ mkxp / game log ================"
grep -E "mkxp|TimeWardens|SDL|libc|DEBUG|AndroidRuntime|ruby|Ruby" "$OUT/logcat.txt" \
  | grep -vE "SDL.*(onWindowFocusChanged|nativeResume|nativePause|surfaceChanged)" | tail -400

echo "================ crashes / errors ================"
if grep -E "FATAL EXCEPTION|Fatal signal|SIGSEGV|SIGABRT|backtrace:" "$OUT/logcat.txt"; then
  log "!! native or Java crash detected"; FAIL=1
fi
grep -iE "error|exception" "$OUT/logcat.txt" | grep -iE "mkxp|ruby|script|TimeWardens" | head -50

if [ "$FAIL" -ne 0 ]; then
  log "EMULATOR TEST: FAILED"
  exit 1
fi
log "EMULATOR TEST: PASSED (check screenshots above)"
