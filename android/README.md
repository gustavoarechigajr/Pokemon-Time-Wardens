# Time Wardens for Android

This folder turns the Windows game into a standalone Android app (`.apk`)
that installs on any phone, tablet or handheld running Android 6.0 or newer.
It doesn't need JoiPlay or any other player app. It is tuned for the
**AYN Thor Max** (built-in controller and a second screen), but works on any
device.

* [Getting the APK](#getting-the-apk)
* [Installing](#installing-on-a-device)
* [Updates](#updates-in-the-app)
* [Controls](#controls)
* [Dual-screen devices](#dual-screen-devices-eg-ayn-thor-max)
* [How it works](#how-it-works)
* [Building and testing](#building-and-testing)
* [Signing](#signing)

## Getting the APK

Every push to `main` (or to a `ccr-*` branch) runs the **Android APK**
workflow in GitHub Actions (`.github/workflows/android-apk.yml`). Pushes
that only change Markdown files are skipped. When the workflow finishes, the
APK is attached to the **`android-latest`** release:

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
build is signed with the same key (see [Signing](#signing)).

## Updates (in the app)

Once installed, you never need to download the big APK again. Every time
you open the game it quickly checks the `android-latest` release, if you're
online:

* **Game updates** (scripts, maps, graphics, audio...) download **only the
  files that changed**. The app compares its list of installed files and
  checksums with the release's list, then fetches just those files out of
  the published `game.zip` (HTTP range requests). Files removed from the
  game are removed too. A typical script fix is a few hundred KB.
* **App updates** (engine, controls, second screen...) download the small
  `TimeWardens-update.apk` (the app without the bundled game) and hand it
  to Android's installer. It installs over the current app and keeps your
  game files and saves.

Either way you get an **Update now / Later** prompt with the download size.
Offline, the game just starts.

The release must be publicly downloadable (a **public repository**) for the
app to fetch updates. Each build publishes these files:

| File | Used for |
|------|----------|
| `TimeWardens-2.05-android.N.apk` | first install (includes the whole game) |
| `TimeWardens-update.apk` | app updates |
| `game.zip`, `game-manifest.json.gz` | game updates (changed files only) |
| `version.json` | the update check |

## Controls

### Touch

On touchscreens an on-screen gamepad appears. It hides when a keyboard or
controller is used and comes back when you touch the screen.

| Button | Game action |
|--------|-------------|
| D-pad  | Move / navigate menus |
| OK     | Use / confirm |
| Back   | Cancel / back |
| Menu   | Open the pause menu (Essentials' Action input) |
| X / Y  | Jump up / down in lists |
| Z      | Special (Ready Menu) |
| Fast / Slow | Speed up / slow down |

### Controllers and handhelds

Built-in controls (e.g. AYN Thor Max) and Bluetooth/USB pads work directly.
The touch overlay starts hidden when a controller is detected and appears
if you touch the screen.

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
the second screen becomes a **touch companion screen**, like the bottom
screen of the DS games. It is drawn with Time Wardens' own artwork, fonts
and sounds. Tabs along the bottom switch pages; during a battle the first
tab becomes **BATTLE** and the battle page opens by itself.

### PARTY

A live copy of the in-game party screen: each Pokémon's own Poké Ball,
animated icons, HP bars that drain and refill in battle, level, gender,
status, shiny star and held item. Eggs show the steps left until they
hatch.

* Tap a Pokémon for its **summary**: INFO (types, ability, nature, held
  item, EXP), STATS (with IVs/EVs) and MOVES (type, category, PP, power,
  accuracy).
  * **USE ITEM**: pick a healing item from your bag (Potions, Revives,
    status cures...) and use it on that Pokémon, with the game's own item
    effects and messages.
  * **SWAP**: then tap another Pokémon to swap their places.
* **TYPES** opens the **team type chart** (Time Wardens' own types): one
  column per Pokémon, one row per type. Each cell shows the damage that
  Pokémon takes from the type, with both of its types combined: 2x or 4x
  (red), 1/2 or 1/4 (green), 0 (blue). A star marks where that Pokémon has
  a move that hits the type super effectively. The list scrolls.

### BATTLE

Laid out like the DS games' touch screen, using Time Wardens' own battle
buttons. Battle text and HP stay on the top screen, and the physical
buttons keep working as usual.

* **Commands**: a big **FIGHT** button with **BAG**, **RUN** and
  **POKÉMON** below it. **FOE INFO** (top right) shows the opponent's
  types, stat changes, status, possible abilities and whether you've
  caught that species.
* **FIGHT**: one button per move, in its type's colour, with its type,
  physical/special/status icon and PP (in the game's PP colours), and, as
  on the 3DS, whether it's *super effective*, *effective*, *not very
  effective* or has *no effect* on the opponent (using the game's own type
  chart). **ACTION**, **CANCEL** and **SHIFT** sit in a row below, next to
  **INFO**, which toggles move details: a panel with the move's category,
  power, accuracy, effect chance, priority and description (tap a move
  once to read about it, again to use it). The choice is remembered.
* **POKÉMON**: your team with HP, status and how each matches up against
  the opponent ("Hits foe hard", "Weak to foe", "Resists foe"); tap one to
  switch to it.
* **BAG**: Poké Balls, medicine and battle items as big buttons. Balls and
  battle items are used with one tap; medicine then asks which Pokémon.
* **TOP SCREEN** (in POKÉMON and BAG) opens the game's own menu instead,
  for summaries, Ethers and the like.

Choices made here go through the game's own battle code, so all the usual
rules, checks and messages apply; only the menus are skipped. Battle
controls dim until the game has acted on a choice, so it can't be sent
twice.

### JOURNAL

The BW-style location sign, your current story objective (tap for the next
part of long ones), trainer name, money, play time, the in-game clock and
season, and the chapters earned. **QUEST LOG** lists every active and
completed quest.

### MAP

* **REGION**: the region's Town Map with your position. Tap a place to see
  its name; if you can Fly and it's a Fly destination, **FLY** takes you
  there.
* **AREA**: a live map of the place you're in, drawn from the map's own
  tiles at half size, with people, items and you as the game's sprites. It
  follows you as you walk, gliding between tiles.

### ROUTE

The wild Pokémon of the current area for the time of day, with encounter
rates and levels. Unseen Pokémon stay silhouettes and "???"; caught ones get
a Poké Ball mark.

### LOG

The last 30 lines of dialogue, in case you skipped past one.

### MORE

**MENU** (pause menu), **SAVE**, **SPEED** (the current game speed, which
on PC only appears in the window title), **REPEL** (uses your next Repel;
steps left are shown), **Items & tools** (your registered key items such as
the Bicycle and rods, plus the field tools you own: Lantern, Sweet Scent,
Defog, Weather Gadget, Camouflage, Dig, Teleport, and the Nimbus, which
opens the MAP page so you can pick where to fly) and **SCREEN OFF**, which
blanks the second screen until you tap it. The app remembers the page and
the on/off choice.

### Naming

When the game asks you to type a name (including nicknaming a Pokémon you
just caught), the second screen turns into a **keyboard** (letters,
numbers, SPACE, DEL, OK).

### General

* Actions from the second screen are carried out only when the game is
  free (on the map, not during a message or a cutscene); otherwise a short
  note explains why. Messages such as "it won't have any effect" come from
  the game itself.
* Touching the second screen never takes focus away from the physical
  controls. Taps give a light vibration, show the pressed button at once and
  play the game's own menu sounds at its sound-effect volume.
* Before a save is loaded, the second screen shows the Time Wardens title.
* Nothing extra runs on single-screen devices.

## How it works

### Engine

The game runs on mkxp-z, the same engine as `Game.exe`, using the community
Android port pinned in `port/port.env`. `port/apply.sh` patches that port:

* builds the engine and Ruby with optimisations on (the port defaults to a
  slow debug build)
* adds 16 KB page-size alignment for newer devices
* removes the "All files access" / storage permission requests
* copies in `overlay/` (the app's Java code, manifest, Gradle config)

### Game files

* `tools/package_game.py` zips the game into the APK's assets as
  `game.zip`. On first launch, `GameInstallActivity` unpacks it into the
  app's private storage
  (`Android/data/com.gustavoarechigajr.timewardens/files/game`). Essentials
  reads its scripts with plain Ruby file access, so they have to exist as
  real files.
* **Windows-only files** (`Game.exe`, DLLs, the PokeRover tool, shortcuts)
  are left out.
* **Audio is normalised** to formats the Android engine definitely decodes.
  MP3 sound effects, and the `.ogg` files that really contain MP3 or WAV
  data (including the main battle themes, Victory! and the Poké Center
  music), are re-encoded to Ogg Vorbis.
* **MIDI music** is rendered to Ogg with the game's `soundfont.sf2` at build
  time, because the Android engine has no MIDI synthesizer. Where a track
  already exists as `.ogg`, the `.mid` copy is dropped.
* **Saves** go to the app's internal data folder, the Android equivalent of
  `%APPDATA%`. They survive game and app updates. Uninstalling the app
  deletes them.

### Android fixes added to the game

These are added to the APK only (`game_patches/`); the PC version is
unchanged.

* `Scripts/000_Android_Compat.rb`: file lookups ignore upper/lower case
  like Windows does, in case a device stores app files on case-sensitive
  storage (some paths in the game don't match the real file names' case).
  Zlib, needed to load the plugins, is loaded explicitly, with a pure-Ruby
  fallback.
* `Mods/Android_Fixes.rb`: the game always stays fullscreen (its "Screen
  Size" option would otherwise bring Android's status and navigation bars
  over the game), and quicksave (R2) works on the map.
* F12 soft-reset is turned off in `mkxp.json`, because the game's handler
  would relaunch `Game.exe` and quit, which just closes the app on Android.

### Second screen

* `game_patches/Mods/Android_DualScreen.rb` (loaded through the game's
  existing `Mods` folder support) runs only while a second screen is
  attached. It writes a small status file into a folder in the app's
  internal storage (passed to the game as `TW_IPC_DIR`). Only the parts that
  change often (menus, battle, position, text entry) are rebuilt on each
  update; party, bag, map and type-chart data are refreshed about once a
  second, or right away when they change. The status is written the moment
  a battle menu opens, a choice is made or the player moves.
* The area map's tiles are written to their own file once per map.
* `SecondScreenView.java` is notified of each change (no polling delay) and
  draws the pages at the game's 512x384 resolution, scaled up
  pixel-perfect. Taps are sent back as small command files, which the mod
  picks up within two frames and runs inside the game when it's safe to.
  Battle choices are handed to the game's own menu and battle code.

## Building and testing

The workflow has three jobs:

1. **native**: cross-compiles the engine's native dependencies (Ruby,
   OpenAL, OpenSSL, ...) for each CPU type (arm64-v8a, armeabi-v7a,
   x86_64). Cached until `android/port/` changes.
2. **apk**: packages the game, builds and signs the full and update APKs,
   and publishes the `android-latest` release. The compiled engine
   libraries are cached too, so a build only recompiles them when
   `android/port/` or the NDK version changes. A normal build takes about
   16 minutes in total.
3. **test**: installs the APK on an Android 11 emulator, boots the game,
   presses through the title screen with gamepad and D-pad input, and checks
   logcat for engine errors and crashes (`tools/emulator_test.sh`). It then
   attaches a simulated second display, taps through its tabs, and restarts
   the app with sample data (`--es tw_demo battle|fight|info|map|entry`, from
   `assets/tw_demo_status.json` and `tw_demo_area.json`) to screenshot every
   second-screen page. Screenshots are printed base64-encoded in the job's
   log (`==SHOT name== ...`).

## Signing

APKs are signed with a private key stored only in the repository's
Actions secrets: `TW_KEYSTORE_BASE64` (the keystore file, base64),
`TW_KEYSTORE_PASSWORD` and `TW_KEY_PASSWORD` (key alias `timewardens`). The
build fails if they're missing. Every build signed with the same key can
update the installed app, so keep a backup of the keystore file. Without it,
installed copies would have to be uninstalled (losing saves) before a build
with a new key installs.
