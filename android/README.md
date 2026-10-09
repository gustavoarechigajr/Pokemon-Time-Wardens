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

## Updates (in the app)

Once installed, you never need to download the big APK again. Every time
you open the game it quickly checks the `android-latest` release, if you're
online:

* **Game updates** (scripts, maps, graphics, audio...) download **only the
  files that changed**. The app compares its list of installed files and
  checksums with the release's list, then fetches just those files out of
  the published `game.zip`. A typical script fix is a few hundred KB.
* **App updates** (engine, controls, second screen...) download the small
  `TimeWardens-update.apk`, which is the app without the bundled game, and
  hand it to Android's installer. It installs over the current app and keeps
  your game files and saves.

Either way you get an **Update now / Later** prompt with the download size.
Offline, the game just starts.

The release must be publicly downloadable (a **public repository**) for the
app to fetch updates. Each build publishes these files to the release:

| File | Used for |
|------|----------|
| `TimeWardens-2.05-android.N.apk` | first install (includes the whole game) |
| `TimeWardens-update.apk` | app updates |
| `game.zip`, `game-manifest.json.gz` | game updates (changed files only) |
| `version.json` | the update check |

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
| Back   | Cancel / back (X) |
| Menu   | Open the pause menu (Z, Essentials' Action input) |
| X / Y  | Jump up / jump down in lists (A / S keys) |
| Z      | Special (D) |
| Fast / Slow | Speed up / slow down (Q / W) |

**Controllers / handhelds (e.g. AYN Thor Max):** built-in controls and
Bluetooth/USB pads work directly. The touch overlay starts hidden when a
controller is detected and appears if you touch the screen.

| Controller | Game action |
|------------|-------------|
| D-pad / left stick | Move / navigate |
| A (bottom) | OK / confirm |
| B (right) | Back / cancel |
| X (left) or Start | Open the pause menu |
| Y (top) or Select | Special (Ready Menu) |
| L1 / R1    | Speed up / slow down |
| L2         | Jump up in lists |
| R2         | Jump down in lists / quicksave on the map |

If confirm and back feel swapped on your device, check its controller
layout setting (Xbox vs. Nintendo style).

The phone's own back button/gesture acts as the game's **Back** button. It
doesn't close the game, so an accidental swipe can't lose unsaved progress.
Keyboards also work.

## Dual-screen devices (e.g. AYN Thor Max)

When the device has a second screen, the game runs on the main screen and
the second screen becomes a **touch companion screen**. It is drawn with the
game's own artwork and fonts, so it looks like part of Time Wardens. Tabs
along the bottom switch pages:

* **PARTY**: a live copy of the in-game party screen (each Pokémon's own
  Poké Ball, animated icons, HP bars that drain and refill in battle,
  level, gender, status, shiny star, held item). Tap a Pokémon for its
  **summary**: INFO (types, ability, nature, held item, EXP), STATS (with
  IVs/EVs) and MOVES (type, PP, power, accuracy, category, description).
  From there:
  * **USE ITEM**: pick a healing item from your bag (Potions, Revives,
    status cures...) and use it on that Pokémon, with the game's own
    item effects and messages.
  * **SWAP**: then tap another Pokémon to swap their places.
* **BATTLE** (replaces the first tab during battles and opens by itself):
  laid out like the DS games' touch screen, using Time Wardens' own battle
  buttons: a big FIGHT button with BAG, RUN and POKÉMON below it. The move
  list shows each move's name, type and PP (in the game's PP colours) and,
  as on the 3DS, whether it's super effective, effective, not very effective
  or has no effect on the opponent (with the game's custom type chart).
  ACTION, CANCEL and SHIFT sit in one row below. Battle text and HP stay on
  the top screen; the physical buttons keep working as usual.
* **JOURNAL**: the BW-style location sign, your current story objective
  (tap for the next part of long ones), trainer name, money, play time,
  the in-game clock and season and the chapters earned. **QUEST LOG** lists
  every active and completed quest.
* **MAP**: the region's Town Map with your position. Tap a place to see its
  name; if you can Fly and it's a Fly destination, **FLY** takes you there.
* **ROUTE**: the wild Pokémon of the current area for the time of day, with
  encounter rates and levels. Unseen Pokémon stay silhouettes and "???";
  caught ones get a Poké Ball mark.
* **LOG**: the last 30 lines of dialogue, in case you skipped past one.
* **MORE**: **MENU** (pause menu), **SAVE**, **SPEED** (the current game
  speed, which on PC only appears in the window title), **REPEL** (uses
  your next Repel, steps left shown), your registered key items (Bicycle,
  rods...) and **SCREEN OFF**, which blanks the second screen until you tap
  it. The app remembers the page and the on/off choice.

When the game asks you to type a name, the second screen turns into a
**keyboard** (letters, numbers, SPACE, DEL, OK).

Actions from the second screen are only carried out when the game is free
(on the map, not during a message or a cutscene); otherwise a short note
explains why. Errors such as "it won't have any effect" come from the game
itself.

Touching the second screen never takes focus away from the physical
controls. Before a save is loaded it shows the Time Wardens title.

How it works: `game_patches/Mods/Android_DualScreen.rb` (loaded through the
game's existing `Mods` folder support) writes a small status file while the
second screen is open. `SecondScreenView.java` draws the pages from it at
the game's 512x384 resolution and scales them up pixel-perfect; taps are
sent back as small command files that the mod runs inside the game.
Nothing extra runs on single-screen devices.

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
* **Audio is normalised** so everything is in a format the Android engine
  definitely decodes. MP3 sound effects, and the 123 `.ogg` files that really
  contain MP3 or WAV data (including the main trainer/wild battle themes,
  Victory! and the Poké Center music), are re-encoded to Ogg Vorbis.
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
  * Zlib (needed to load the plugins) is loaded explicitly, with a
    pure-Ruby fallback in case the engine can't provide it.
  * The game always stays fullscreen; its "Screen Size" option would
    otherwise bring Android's status and navigation bars over the game.
  * F12 soft-reset is turned off, because the game's handler would relaunch
    `Game.exe` and quit, which just closes the app on Android.
* **Saves** go to the app's internal data folder, the Android equivalent of
  `%APPDATA%`. They survive game updates. Uninstalling the app deletes them.

## Testing

The workflow's last job installs the APK on an Android 11 emulator, boots
the game, presses through the title screen and checks logcat for engine
errors and crashes (`tools/emulator_test.sh`). It also attaches a simulated
second display, taps through its tabs, and restarts once with sample data
(`--es tw_demo battle|fight|map|entry`, from `assets/tw_demo_status.json`) to screenshot every
second-screen page, including the battle page and a summary. Screenshots are
printed base64-encoded in that job's log.

## Signing

APKs are signed with a private key stored only in the repository's
Actions secrets: `TW_KEYSTORE_BASE64` (the keystore file, base64),
`TW_KEYSTORE_PASSWORD` and `TW_KEY_PASSWORD` (key alias `timewardens`). The
build fails if they're missing. Every build signed with the same key can
update the installed app, so keep a backup of the keystore file. Without it,
installed copies would have to be uninstalled (losing saves) before a build
with a new key installs.
