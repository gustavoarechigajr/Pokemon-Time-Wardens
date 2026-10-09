#!/usr/bin/env python3
"""Package the Time Wardens game folder for the Android APK.

Produces two files for the APK's assets folder:
  game.zip         the game files the engine needs at runtime
  game.properties  size/id info read by GameInstallActivity

Android-specific handling:
  * Windows-only files (Game.exe, DLLs, the PokeRover tool, shortcuts...)
    are left out.
  * Files under android/game_patches/ are added on top of the game (Android-
    only compatibility scripts).
  * MIDI music is rendered to Ogg Vorbis with the game's own soundfont.
    The Android engine has no FluidSynth, so .mid files would be silent
    (or raise errors) on a phone. Essentials looks audio up without an
    extension, so "Audio/BGM/Route 1" finds the .ogg just like the .mid.

Usage: package_game.py <game_dir> <out_dir> [--midi-cache DIR]
"""

import argparse
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import zipfile

# Top-level entries that are not part of the runtime game
EXCLUDE_TOP = {
    ".git", ".github", ".gitattributes", ".gitignore", "android", "dist",
    "Reference Documents", "Game.exe", "RGSS104E.dll", "animmaker.exe",
    "animmaker.txt", "extendtext.exe", "extendtext.txt", "knownpoint.bmp",
    "selpoint.bmp", "townmapgen.html", "Save File Shortcut.lnk",
    "libTolk.dll", "nvdaControllerClient.dll", "x64-msvcrt-ruby310.dll",
    "zlib1.dll", "patches.json", "Text-To-Speech Readme.txt",
}
# File names / extensions skipped anywhere in the tree
EXCLUDE_NAMES = {"desktop.ini", "Thumbs.db", ".DS_Store"}
EXCLUDE_EXT = {".exe", ".dll", ".lnk", ".code-workspace"}

MIDI_EXT = {".mid", ".midi"}

# Engine settings changed for Android (merged into the game's mkxp.json)
MKXP_OVERRIDES = {
    # F12 soft-reset: the game's handler relaunches Game.exe and quits, which
    # on Android just closes the app.
    "enableReset": False,
    # MIDI is pre-rendered to Ogg, no soundfont is shipped
    "midiSoundFont": "",
}

# Already-compressed formats are stored, everything else is deflated
STORE_EXT = {".png", ".ogg", ".mp3", ".jpg", ".jpeg", ".gif", ".zip", ".ogv"}


def included(rel):
    parts = rel.split("/")
    if parts[0] in EXCLUDE_TOP:
        return False
    name = parts[-1]
    if name in EXCLUDE_NAMES:
        return False
    if os.path.splitext(name)[1].lower() in EXCLUDE_EXT:
        return False
    return True


def render_midi(src, dst, soundfont, cache_dir):
    """Render one MIDI file to Ogg Vorbis (cached by content hash)."""
    with open(src, "rb") as f:
        digest = hashlib.sha256(f.read() + b"|" + open(soundfont, "rb").read(4096)).hexdigest()
    cached = os.path.join(cache_dir, digest + ".ogg") if cache_dir else None
    if cached and os.path.isfile(cached):
        shutil.copyfile(cached, dst)
        return
    with tempfile.TemporaryDirectory() as tmp:
        wav = os.path.join(tmp, "out.wav")
        subprocess.run(["fluidsynth", "-ni", "-q", "-g", "0.6", "-r", "44100",
                        "-F", wav, soundfont, src],
                       check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        # Peak-normalise to -1 dB so rendered tracks sit at a similar level
        # to the game's Ogg music.
        probe = subprocess.run(["ffmpeg", "-i", wav, "-af", "volumedetect", "-f", "null", "-"],
                               capture_output=True, text=True)
        gain = 0.0
        for line in probe.stderr.splitlines():
            if "max_volume:" in line:
                gain = max(0.0, -1.0 - float(line.split("max_volume:")[1].split()[0]))
        # Trim trailing silence (fluidsynth renders release tails) so loops
        # restart promptly, then encode.
        subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", wav,
                        "-af", "volume=%.1fdB,areverse,silenceremove=start_periods=1:start_threshold=-70dB,areverse" % gain,
                        "-c:a", "libvorbis", "-q:a", "5", dst], check=True)
    if not os.path.getsize(dst):
        raise RuntimeError("empty render for " + src)
    if cached:
        os.makedirs(cache_dir, exist_ok=True)
        shutil.copyfile(dst, cached)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("game_dir")
    ap.add_argument("out_dir")
    ap.add_argument("--midi-cache", default=None)
    ap.add_argument("--patches", default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "game_patches"))
    args = ap.parse_args()

    game = os.path.abspath(args.game_dir)
    out = os.path.abspath(args.out_dir)
    os.makedirs(out, exist_ok=True)
    soundfont = os.path.join(game, "soundfont.sf2")

    files = []
    for root, dirs, names in os.walk(game):
        dirs.sort()
        rel_root = os.path.relpath(root, game).replace(os.sep, "/")
        if rel_root != "." and not included(rel_root):
            dirs[:] = []
            continue
        for n in sorted(names):
            rel = n if rel_root == "." else rel_root + "/" + n
            if included(rel):
                files.append(rel)

    # Map lowercase "dir/stem" of every non-MIDI audio file, so a MIDI that
    # already has an Ogg/WAV twin is simply dropped instead of rendered.
    audio_stems = set()
    for rel in files:
        stem, ext = os.path.splitext(rel)
        if rel.startswith("Audio/") and ext.lower() not in MIDI_EXT:
            audio_stems.add(stem.lower())

    zip_path = os.path.join(out, "game.zip")
    total = 0
    rendered = dropped = 0
    with tempfile.TemporaryDirectory() as tmp, \
            zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED, compresslevel=6, allowZip64=True) as zf:
        for rel in files:
            src = os.path.join(game, rel)
            stem, ext = os.path.splitext(rel)
            arcname = rel
            if ext.lower() in MIDI_EXT:
                if stem.lower() in audio_stems:
                    dropped += 1
                    print("drop MIDI (ogg twin exists):", rel)
                    continue
                if not os.path.isfile(soundfont):
                    sys.exit("soundfont.sf2 missing, cannot render " + rel)
                ogg = os.path.join(tmp, "midi.ogg")
                render_midi(src, ogg, soundfont, args.midi_cache)
                src = ogg
                arcname = stem + ".ogg"
                audio_stems.add(stem.lower())
                rendered += 1
                print("rendered MIDI:", rel, "->", arcname)
            if rel == "soundfont.sf2":
                continue  # only needed for MIDI, which is rendered above
            if rel == "mkxp.json":
                with open(src, encoding="utf-8") as f:
                    text = re.sub(r"^\s*//.*$", "", f.read(), flags=re.M)
                conf = json.loads(text)
                conf.update(MKXP_OVERRIDES)
                data = json.dumps(conf, indent=4).encode("utf-8")
                zf.writestr(arcname, data, compress_type=zipfile.ZIP_DEFLATED)
                total += len(data)
                continue
            comp = zipfile.ZIP_STORED if os.path.splitext(arcname)[1].lower() in STORE_EXT else zipfile.ZIP_DEFLATED
            zf.write(src, arcname, compress_type=comp)
            total += os.path.getsize(src)

        # Android-only additions/overrides
        patches = os.path.abspath(args.patches)
        for root, dirs, names in os.walk(patches):
            dirs.sort()
            for n in sorted(names):
                src = os.path.join(root, n)
                arcname = os.path.relpath(src, patches).replace(os.sep, "/")
                if arcname in files:
                    sys.exit("game patch would overwrite an existing game file: " + arcname)
                zf.write(src, arcname)
                total += os.path.getsize(src)
                print("added Android patch:", arcname)

    with open(zip_path, "rb") as f:
        h = hashlib.sha256()
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    with open(os.path.join(out, "game.properties"), "w") as f:
        f.write("id=%s\n" % h.hexdigest()[:16])
        f.write("uncompressed_bytes=%d\n" % total)
        f.write("files=%d\n" % (len(files) - dropped))

    print("Packaged %d files, %.1f MB uncompressed, zip %.1f MB; MIDI rendered %d, dropped %d"
          % (len(files) - dropped, total / 1e6, os.path.getsize(zip_path) / 1e6, rendered, dropped))


if __name__ == "__main__":
    main()
