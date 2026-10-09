# Time Wardens for Android

This folder turns the Windows game into a standalone Android app (`.apk`)
that can be installed on any phone or tablet (Android 6.0 or newer). It
doesn't need JoiPlay or any other player app.

## Getting the APK

Every push to `main` (or to a `ccr-*` branch) runs the **Android APK**
workflow in GitHub Actions (`.github/workflows/android-apk.yml`). When it
finishes, the APK is attached to the **`android-latest`** release:

> GitHub → Releases → *Time Wardens for Android (build N)* → `TimeWardens-2.05-android.N.apk`

You can also start a build by hand from the Actions tab ("Run workflow").

## Installing on a device

1. Download the `.apk` on the device (or copy it over from a computer).
2. Open it. Android asks you to allow installing apps from that source
   (your browser or file manager). Allow it, then tap **Install**.
3. Open **Time Wardens**. On the first launch (and after each update) the
   app spends a minute or two unpacking the game files. After that it
   starts straight into the game.

Space needed: about 1.2 GB for the app plus 1.3 GB for the unpacked
game files.

Updates install over the old version and keep your saves, because every
build is signed with the same key (see *Signing* below).

## Controls

On touchscreens an on-screen gamepad appears. It hides when a keyboard or
controller is used and comes back when you touch the screen.

| Button | Game action |
|--------|-------------|
| D-pad  | Move / navigate menus |
| OK     | Use / confirm (C) |
| Back   | Cancel / open the menu (X) |
| Act    | Action (Z) |
| X / Y  | Jump up / jump down in lists (A / S keys) |
| Z      | Special (D) |
| Fast / Slow | Speed up / slow down (Q / W) |

The phone's own back button/gesture acts as the game's **Back** button. It
doesn't close the game, so an accidental swipe can't lose unsaved progress.
Bluetooth/USB controllers and keyboards also work.

## How it works

* **Engine**: the game runs on mkxp-z, the same engine as `Game.exe`, using
  the community Android port pinned in `port/port.env`. `port/apply.sh`
  patches that port:
  * builds the engine and Ruby with optimisations on (the port defaults to
    a slow debug build)
  * adds 16 KB page-size alignment for newer devices
  * removes the "All files access" / storage permission requests
* **Game files**: `tools/package_game.py` zips the game into the APK's
  assets as `game.zip`. On first launch, `GameInstallActivity` unpacks it
  into the app's private storage
  (`Android/data/com.gustavoarechigajr.timewardens/files/game`).
  Essentials reads its scripts with plain Ruby file access, so they have to
  exist as real files.
* **Windows-only files** (`Game.exe`, DLLs, the PokeRover tool, shortcuts)
  are left out of the APK.
* **MIDI music** is rendered to Ogg with the game's `soundfont.sf2` at build
  time, because the Android engine has no MIDI synthesizer. Where a track
  already exists as `.ogg`, the `.mid` copy is dropped.
* **Android fixes added to the game** (APK only, the PC version is
  unchanged):
  * `game_patches/Scripts/000_Android_Compat.rb` makes the game's file
    lookups ignore upper/lower case, like Windows does, in case a device
    stores app files on case-sensitive storage. Some paths in the game don't
    match the real file names' case, e.g. `Graphics/windowskins/...` vs. the
    `Windowskins` folder, or the title music `Title` vs. `title.ogg`.
  * F12 soft-reset is turned off, because the game's handler would relaunch
    `Game.exe` and quit, which just closes the app on Android.
* **Saves** go to the app's internal data folder, the Android equivalent of
  `%APPDATA%`. They survive game updates. Uninstalling the app deletes them.

## Testing

The workflow's last job installs the APK on an Android 11 emulator, boots
the game, presses through the title screen and checks logcat for engine
errors and crashes (`tools/emulator_test.sh`). Screenshots are printed
base64-encoded in that job's log.

## Signing

APKs are signed with `keystore/release.jks` (alias `timewardens`, password
`timewardens`) so every build can update the previous one. The repository
is private, so this is fine for personal use. If you want your own private
key instead, add these repository secrets and the workflow will use them:

* `TW_KEYSTORE_BASE64`: your keystore file, base64-encoded
* `TW_KEYSTORE_PASSWORD`, `TW_KEY_PASSWORD`

Changing the key means already-installed copies have to be uninstalled once
before the new build will install.
