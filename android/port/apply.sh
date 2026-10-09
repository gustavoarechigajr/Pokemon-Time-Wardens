#!/usr/bin/env bash
# Applies the Time Wardens changes on top of a checkout of the mkxp-z
# Android port (see port.env for the pinned revision).
#
#   android/port/apply.sh <path-to-port-checkout>
set -euo pipefail

PORT_DIR="$(cd "$1" && pwd)"
HERE="$(cd "$(dirname "$0")" && pwd)"
OVERLAY="$HERE/../overlay"
JNI="$PORT_DIR/app/jni"

echo "Applying Time Wardens overlay to $PORT_DIR"

# 1. Files that are replaced or added wholesale (Java, manifest, gradle, icons)
cp -R "$OVERLAY"/. "$PORT_DIR"/

# App name shown under the launcher icon
sed -i -E 's|(<string name="app_name"[^>]*>)[^<]*(</string>)|\1Time Wardens\2|' \
  "$PORT_DIR/app/src/main/res/values/strings.xml"
grep -q '>Time Wardens<' "$PORT_DIR/app/src/main/res/values/strings.xml"

# 2. Native build: optimise. The port builds everything at -O0 / APP_OPTIM
#    debug, which makes Ruby (and so the whole game) several times slower.
sed -i 's/^CFLAGS      := -O0 /CFLAGS      := -O2 -DNDEBUG /' "$JNI/Makefile"
grep -q '^CFLAGS      := -O2 ' "$JNI/Makefile"
sed -i 's/^APP_OPTIM := debug/APP_OPTIM := release/' "$JNI/Application.mk"
grep -q '^APP_OPTIM := release' "$JNI/Application.mk"
# ABIs come from Gradle (abiFilters); 16 KB page alignment for newer devices
sed -i 's/^APP_ABI := .*/APP_ABI := arm64-v8a armeabi-v7a x86_64/' "$JNI/Application.mk"
grep -q 'max-page-size' "$JNI/Application.mk" || \
  echo 'APP_LDFLAGS += -Wl,-z,max-page-size=16384' >> "$JNI/Application.mk"

# 3. Engine: the game lives in app-specific storage now, so never ask for
#    the legacy storage permission (a "deny" would abort the game).
python3 - "$JNI/mkxp-z/src/main.cpp" <<'PY'
import sys
p = sys.argv[1]
s = open(p).read()
old = '''	// Request storage permission (before Android 11)
	if (sdkVersion < 30) {
		if (!SDL_AndroidRequestPermission("android.permission.WRITE_EXTERNAL_STORAGE")) {
			showInitError("Failed to get external storage. Please check the app permissions.");
			SDL_Quit();
			return 0;
		}
	}
'''
if old not in s:
    sys.exit("main.cpp: storage permission block not found")
s = s.replace(old, '''	// Time Wardens: game files are in app-specific storage, no permission needed
	(void)sdkVersion;
''')
open(p, 'w').write(s)
PY

echo "Overlay applied."
