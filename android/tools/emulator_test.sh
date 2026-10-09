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

# Title screen -> continue/new game menu -> new game, pressing "C" (Use)
for step in 1 2 3 4 5 6; do
  key KEYCODE_C
  sleep 6
  shot "press_c_${step}"
  check_alive || { FAIL=1; break; }
done

# Walk around a bit / advance dialogue
for step in 1 2 3 4 5 6 7 8 9 10; do
  key KEYCODE_C
  sleep 3
done
shot "after_dialogue"
key KEYCODE_DPAD_DOWN KEYCODE_DPAD_DOWN KEYCODE_DPAD_LEFT KEYCODE_DPAD_RIGHT
sleep 3
shot "after_walk"
# Open the pause menu (Back) and close it again
key KEYCODE_X; sleep 4; shot "menu"; key KEYCODE_X; sleep 3
check_alive || FAIL=1

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
