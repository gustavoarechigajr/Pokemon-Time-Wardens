#!/usr/bin/env bash
# Clones the pinned mkxp-z Android port, applies the Time Wardens overlay
# and downloads the port's third-party sources (SDL2, Ruby, ...).
#
#   android/tools/fetch_port.sh <dest-dir>
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=../port/port.env
source "$HERE/../port/port.env"
DEST="$1"

if [ ! -d "$DEST/.git" ]; then
  git clone -q --filter=blob:none "$PORT_REPO" "$DEST"
fi
git -C "$DEST" -c advice.detachedHead=false checkout -q "$PORT_COMMIT"
echo "Port at $(git -C "$DEST" rev-parse HEAD)"

"$HERE/../port/apply.sh" "$DEST"

cd "$DEST/app/jni"
bash ./get_deps.sh
cd mkxp-z
bash ./make_xxd.sh > /dev/null
