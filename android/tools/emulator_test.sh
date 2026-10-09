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

# Fails the test if the game shows an error dialog (Ruby exception, engine
# error). The process stays alive behind such a dialog, so check the screen.
check_errors() {
  adb shell uiautomator dump /sdcard/tw_ui.xml >/dev/null 2>&1 || return 0
  local ui
  ui=$(adb shell cat /sdcard/tw_ui.xml 2>/dev/null)
  if echo "$ui" | grep -qiE "Exception|Backtrace|Script error|Error initializing|Failed to"; then
    log "!! error dialog on screen ($1):"
    echo "$ui" | grep -oE 'text="[^"]{3,}"' | sed 's/^text="//; s/"$//; s/&#10;/\n/g' | head -40
    FAIL=1
    return 1
  fi
  return 0
}

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
timeout 900 adb install -r "$APK" || { log "!! install failed or took over 15 minutes"; exit 1; }
log "Installed"
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
check_errors "after boot"

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

check_errors "title / new game"

# Advance intro dialogue with A
for step in 1 2 3 4 5 6 7 8 9 10; do
  pad KEYCODE_BUTTON_A
  sleep 3
done
shot "after_dialogue"
check_errors "intro"

# D-pad movement from a controller
dpad KEYCODE_DPAD_DOWN KEYCODE_DPAD_DOWN KEYCODE_DPAD_LEFT KEYCODE_DPAD_RIGHT
sleep 3
shot "after_walk"

# Start (= Essentials' ACTION input) opens the pause menu, B closes it
pad KEYCODE_BUTTON_START; sleep 4; shot "pad_start_menu"
pad KEYCODE_BUTTON_B; sleep 3; shot "pad_b_closed"

# Keyboard still works (C = OK) and the phone's back key acts as Back
key KEYCODE_BACK; sleep 4; shot "back_key_menu"
key KEYCODE_BACK; sleep 3
check_alive || { log "!! back key closed the game"; FAIL=1; }
check_errors "menus"
grep -q "TimeWardens\[Pad\]" "$OUT/logcat.txt" && log "Controller buttons reached the game" || { log "!! no controller button reached the game"; FAIL=1; }

# Dual screen: attach a simulated second display (like the AYN Thor's
# bottom screen) while the game runs; the info panel should appear on it and
# the game should start writing its status file.
log "Attaching simulated second display"
adb shell settings put global overlay_display_devices 960x540/240
sleep 8
pad KEYCODE_BUTTON_A; sleep 4
shot "dual_screen_main"
adb shell dumpsys display | grep -E "mDisplayId=|mName=|Overlay" | head -10
# Screenshot the second display itself
SECOND_ID=$(adb shell dumpsys SurfaceFlinger --display-id 2>/dev/null | sed -n '2p' | awk '{print $2}')
DISPLAY_NUM=$(adb shell dumpsys display | grep -oE "mDisplayId=[1-9][0-9]*" | head -1 | cut -d= -f2)
echo "second display: logical=$DISPLAY_NUM surfaceflinger=$SECOND_ID"
shot_display() {
  local name="$1"
  if [ -n "$SECOND_ID" ]; then
    adb exec-out screencap -d "$SECOND_ID" -p > "$OUT/$name.png" 2>/dev/null
    convert "$OUT/$name.png" -resize 640x -quality 70 "$OUT/$name.jpg" 2>/dev/null && \
      echo "==SHOT $name== $(base64 -w0 "$OUT/$name.jpg")"
  fi
}
shot_display "second_party"
# Taps on the 960x540 second screen. The 512x384 page is scaled x1.40625
# and centred (x offset 120). tap_v takes coordinates on the 512x384 page;
# the six tabs are 80 wide every 85 px from x=2, at y 334-380.
tap_v() { adb shell input -d "$DISPLAY_NUM" tap "$((120 + $1 * 140625 / 100000))" "$(($2 * 140625 / 100000))"; }
tap_tab() { tap_v "$((2 + $1 * 85 + 40))" 357; }
TABS=(party journal map route log more)
if [ -n "$DISPLAY_NUM" ] && grep -q "Status: ingame=true" "$OUT/logcat.txt"; then
  for i in 1 2 3; do
    tap_tab "$i"; sleep 2; shot_display "second_${TABS[$i]}"
    grep -q "Page ${TABS[$i]}" "$OUT/logcat.txt" && log "Second screen ${TABS[$i]} tab works" || log "!! ${TABS[$i]} tap not registered"
  done
  tap_tab 0; sleep 1
else
  log "Game not in a save yet (second screen shows the title); tabs are checked in the demo pass"
fi
if grep -q "Second screen found" "$OUT/logcat.txt"; then
  log "Dual screen panel opened"
else
  log "!! dual screen panel did not open"; FAIL=1
fi
grep "TimeWardens\[Dual\]" "$OUT/logcat.txt" | tail -5
# Demo pass: restart with sample data (mid-battle, a party, quests, a route)
# so every page of the second screen can be checked in screenshots.
if [ -n "$DISPLAY_NUM" ]; then
  log "Second screen demo pass"
  # In demo mode the view logs each new page as base64 JPEG chunks
  # ("TWShot <seq> <i>/<n> <data>"): overlay displays can't be captured with
  # screencap. demo_shot saves the latest complete image.
  demo_shot() {
    sleep 1
    python3 - "$OUT/logcat.txt" "$OUT/$1.jpg" <<'PY' && echo "==SHOT $1== $(base64 -w0 "$OUT/$1.jpg")"
import base64, re, sys
shots, last = {}, {}
for n, line in enumerate(open(sys.argv[1], errors="replace")):
    m = re.search(r"TWShot\s*\(\s*(\d+)\): (\d+) (\d+)/(\d+) (\S+)", line)
    if m:
        key = (m.group(1), int(m.group(2)))   # (pid, seq): seq restarts with the app
        shots.setdefault(key, {})[int(m.group(3))] = (int(m.group(4)), m.group(5))
        last[key] = n
done = [k for k, v in shots.items() if len(v) == next(iter(v.values()))[0]]
if not done:
    sys.exit(1)
v = shots[max(done, key=lambda k: last[k])]
open(sys.argv[2], "wb").write(base64.b64decode("".join(v[i][1] for i in sorted(v))))
PY
  }
  # Restarts the app with a demo variant (see SecondScreenView.loadDemo)
  demo_start() {
    adb shell am force-stop "$PKG"; sleep 2
    adb shell am start -n "$PKG/com.hatkid.mkxpz.GameInstallActivity" --es tw_demo "$1" > /dev/null
    sleep 20
    grep -q "Demo status loaded ($1)" "$OUT/logcat.txt" && log "Demo status loaded ($1)" || log "!! demo status ($1) not loaded"
  }
  # Mid-battle: battle page, then the party/summary and every other tab
  demo_start battle
  demo_shot "demo_battle"
  tap_tab 0; sleep 2; demo_shot "demo_party_in_battle"
  tap_v 128 48; sleep 2; demo_shot "demo_summary"
  tap_v 354 23; sleep 2; demo_shot "demo_summary_stats"
  tap_v 458 23; sleep 2; demo_shot "demo_summary_moves"
  for i in 1 2 3 4 5; do
    tap_tab "$i"; sleep 2; demo_shot "demo_${TABS[$i]}"
    grep -q "Page ${TABS[$i]}" "$OUT/logcat.txt" || log "!! demo ${TABS[$i]} tap not registered"
  done
  # Move list
  demo_start fight
  demo_shot "demo_fight"
  # Move details (INFO toggle on)
  demo_start info
  demo_shot "demo_fight_info"
  # On the map: party actions enabled, healing items, quick actions
  demo_start map
  tap_tab 0; sleep 2; demo_shot "demo_party"
  tap_v 384 64; sleep 2
  tap_v 86 270; sleep 2; demo_shot "demo_items"
  tap_tab 5; sleep 2; demo_shot "demo_more_free"
  # Naming keyboard
  demo_start entry
  demo_shot "demo_keyboard"
  check_alive || { log "!! game died during the demo pass"; FAIL=1; }
fi
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
