# classic_snake — Complete Project Context for AI Agents

> This file is a full, self-contained map of the **classic_snake** Flutter project
> (a classic Snake game published on Google Play). An AI agent can rely on this
> document alone to understand the codebase, its logic, conventions, and known
> issues without re-reading every file from scratch.
>
> If any statement below conflicts with actual code, trust the code and update this file.
> All file paths are relative to the repository root.

---

## 1. Project Overview

| Field | Value |
|---|---|
| App name | Snake Classic (label in AndroidManifest) |
| Package / applicationId | `com.gaf.classic_snake` |
| Version | `3.0.0+7` in `pubspec.yaml`; `KCurrentAppVersion = '3.0.1'` in `lib/constant/constant.dart:9` |
| Type | Flutter mobile game (portrait-only, fullscreen) |
| Primary target | Android (Google Play) — AdMob configured for Android only |
| Author credit | "Made By GAF-Programing 2023" (shown in menu) |
| Description | Classic snake with 30 unlockable levels (block obstacles + target score), a free "Survival" mode, a custom level editor, special bonus foods with random effects, and rewarded-video extra life |

### Platform folders
`android/`, `ios/`, `web/`, `windows/` all exist. **Android is the real product target.**

### Git history
`first commit` → `change app structer and change app logic` → `beforeChangeMusic` → `LastRelase` → `AiFix` (HEAD). Working tree has uncommitted Gradle/Manifest/CMake edits (Android build plumbing, likely newer AGP).

---

## 2. Environment & Tooling

- **Flutter**: 3.24.4 — **Dart**: 3.5.4 (pubspec `environment.sdk: "3.5.4"`). Do NOT use APIs newer than Dart 3.5.4 without verification; do not bump the SDK version.
- **Do not migrate frameworks** unless explicitly asked.

### Dependencies (`pubspec.yaml`, resolved in `pubspec.lock`)
| Package | Version | Purpose |
|---|---|---|
| `provider` | 6.1.2 | State management (ChangeNotifier + MultiProvider) |
| `audioplayers` | 6.1.0 | SFX + looping background music |
| `url_launcher` | 6.3.1 | Open Play Store / privacy policy |
| `http` | 1.2.2 | Version check against Firebase RTDB |
| `toast` | 0.3.0 | Toast messages |
| `shared_preferences` | 2.3.2 | All persistence |
| `google_mobile_ads` | 4.0.0 | Banner + rewarded ads (AdMob) |
| `wakelock_plus` | 1.2.11 | Keep screen awake during play |
| dev: `flutter_launcher_icons` | 0.14.1 | Launcher icon generation |

> Note: state management is **Provider**, NOT Riverpod. Do not introduce Riverpod/GetX/Bloc in this project.

### Commands
- Analyze: `flutter analyze` (or `dart analyze`)
- Stage grid is unitless / index-only, so most logic can run headless for tests.
- Tests: `flutter test` — currently **no real tests** (see Known Issues).
- Build release: `flutter build apk --release` / `flutter build appbundle` (Android signing via `android/key.properties`, must exist locally; release build type uses `signingConfigs.release`).

### Assets
- `assets/images/snakehead.png` (menu button image)
- `assets/fonts/Mali-*.ttf` (6 weights: Regular, Medium, Bold, + Italic variants)
- SFX: `eat.wav`, `buttonClick.wav`; music/sfx: `snakebackgroundmusic.mp3`, `snakegameover.mp3`, `snakehieghscorebreak.mp3`, `snakescoredown.mp3`, `snakescoreup.mp3`, `snaketargetdone.mp3`
- **Gotcha**: `pubspec.yaml` declares the font family as **`Mail`** while the files are `Mali-*` and code uses `fontFamily: 'Mail'` (`main.dart:50`). No font is actually registered under family `Mail`, so the Mali font is **never applied** — the app falls back to the default font. (Bug → fix would be renaming the family to `Mali`.)

---

## 3. Architecture & Data Flow

Simple layered structure:

```
UI (lib/screen, lib/widget, lib/gaf_package)
   ↓  Provider (watch/read)
ChangeNotifier / Controllers (StagePlay, AppColorController, GameSound)
   ↓  direct method calls + static state
Game logic (helper/Snake, helper/Stage, SpecialFood, GameTimer)
   ↓
Static global state (view_model/Manager, singleton GameSize)
Persistence (view_model/LevelController → SharedPreferences)
```

### State management summary
Root `MultiProvider` in `lib/main.dart:21-30` provides three ChangeNotifiers app-wide:
1. `StagePlay` — the whole play-session orchestrator (one instance; actively drives the running game).
2. `AppColorController` — selected color theme.
3. `GameSound` — sound/music toggles.

**Critical design reality:** a large share of game state is NOT in the ChangeNotifier — it lives in a static global utility class `Manager` (see below). `StagePlay` reads/writes `Manager.*` constantly. Any UI or game code can touch `Manager` without a provider. This is a tight-coupling/singleton pattern, not a clean Riverpod-style store.

### Navigation flow (named routes, `main.dart:58-65`)
```
LandingScreen (splash animation, GAF logo)  /LandingScreen (home)
   ↓ pushReplacementNamed (after ~4s timer anim)
MenuScreen  /MenuScreen   [START → StageScreen, Option dialog, Exit]
   ↓
StageScreen /stagesScreen [level grid, "Create your own level", update+rating dialogs]
   ├─ StageIcon tap → StagePlay.start(id) → pushReplacement → PlayScreen
   └─ DesignLevel /designLevel (level editor) → save → start(31 customize) → PlayScreen
PlayScreen /PlayScreen (swipe game)
LoadingScreen "LoadingScreen" (registered, appears unused in flow)
```
Navigation between stages uses `pushReplacementNamed` everywhere (no back stack for game screens).

---

## 4. Directory Map (lib/)

```
lib/
├── main.dart                  App entry, MultiProvider, MaterialApp, routes, AdMob init
├── constant/
│   ├── constant.dart          Sound file names, KAppName, KCurrentAppVersion='3.0.1'
│   ├── enum_file.dart         CellType, Direct, FoodType, TapDirect
│   ├── game_values.dart       KSnakeStarting=[30,50,70,90], KDefaultGameSpeed=300, KEatScoreValue=10
│   └── level_indexs.dart      30 const Lists of block cell indices (IndexLevelOne…IndexLevelThirty)
├── model/
│   ├── position.dart          Cell index → (row, col) helper (uses GameSize().cellInRow())
│   ├── level_model.dart       LevelModel class + global `levelList` (32 entries) + all 30 level defs
│   └── color_app.dart         AppColor class + 5 themes (blue/red/green/light/dark) + appColorList
├── view_model/                (logic layer — mostly static/singletons)
│   ├── manager.dart           STATIC global game state + helpers (screenAdjust, showOptionMenu)
│   ├── game_size.dart         GameSize singleton: 20×30 grid math, cell size, margins
│   ├── app_color.dart         AppColorController (ChangeNotifier, persists theme index)
│   ├── sound_controller.dart  GameSound (ChangeNotifier, static players, persists toggles)
│   ├── level_controller.dart  LevelController: per-level unlock/highscore + custom level save/restore
│   ├── timer_controller.dart  GameTimer: 1s-tick elapsed play timer (HH:MM:SS text)
│   ├── special_food.dart      SpecialFood random-reward engine + CreateGiftFoodIndex
│   └── cell/ …                (widget, see below)
├── providers/
│   └── stagePlay.dart         StagePlay ChangeNotifier — main game-loop orchestrator
├── helper/
│   ├── snake.dart             Snake model: body, movement (toroidal wrap), eating, death
│   └── stage.dart             Stage model: per-run food/special-food/reward/timer state
├── screen/                    Landscape of app screens (see §5)
├── widget/                    Reusable/GAF-themed UI (see §6)
├── gaf_package/               Reusable "GAF framework": ads, rating, update, dialogs
│   ├── gaf_service/           ad_manager, app-rating, app-update, open_google_play
│   ├── gaf_widget/            gaf_dialog, gaf_dialog_action_button, app_rating_dialog, app-update-Dialog
│   └── ad_widget/             banner_widget, rewarded_Ad
└── generated_plugin_registrant.dart   (generated, ignore)
```

### Level data model
`LevelModel` (`model/level_model.dart`): `rank` (int?), `targetScore`, `highScore`, `blocks` (List<int> cell indices), `enable`.
`levelList` (global, 32 items):
- `levelList[0]` → **Survival** (rank 0): no obstacles, no target (free play).
- `levelList[1..30]` → ranks 1–30, targets 300→800, each uses `IndexLevel*` block layout. Unlocked by completing the previous level.
- `levelList[31]` → **customize** (rank 999): user-built level restored from storage at runtime.

---

## 5. Screens (lib/screen/)

| File | Route | Behavior |
|---|---|---|
| `landing_screen.dart` | `/LandingScreen` | Typewriter-ish animated "GAF - Programing" splash; after animation → `MenuScreen`. Calls `LevelController(0).setLevelState()` in initState (unlocks Survival). |
| `menu_screen.dart` | `/MenuScreen` | START / Option / Exit big buttons + "Made By GAF-Programing 2023". Starts background music; lifecycle observer pauses game when app backgrounded. Wraps START in a spinner (`LoadingContainer`), then pushes `StageScreen`. |
| `stages_screen.dart` | `/stagesScreen` | Back button, "Levels" title, "Create your own level" button, 3-column grid of `StageIcon`s (itemCount = `levelList.length - 1` to hide customize slot). Runs `AppUpdate(context)` + `AppRating(context)` once per app run (guarded by global `_dialogShow`). |
| `design_level.dart` | `/designLevel` | Level editor: 600-cell grid, tap toggles blocks (snake start cells protected), target score +/-10 (hold to auto-repeat), info dialog, SAVE & PLAY (persists via `LevelController(999)`, replaces `levelList[31]`, starts game), Reset. |
| `play_screen.dart` | `/PlayScreen` | Main playing screen (see §7). |
| `loading_screen.dart` | `LoadingScreen` | Plain spinner screen — registered but **not referenced** in the navigated flow. |

---

## 6. Widgets (lib/widget/ + gaf_package/)

### Game/widget rendering
- `widget/cell/cell.dart` — builds a board cell for a `CellType`: blocks (blue circles on grey), snake segments (rounded bars), snake **head** (with eyes, oriented by direction), snake **corners**, food (green), special food (green with `?` icon). Uses `CellProp` + `RotatedBox(quarterTurns)` for rotation logic. **Colors here are largely hardcoded** (blue/green/grey), so the selectable color theme mostly affects chrome, not the playfield.
- `widget/game_menu.dart` — the pause/game-over overlay (slide-up panel). Buttons: Continue (rewarded video for extra life), Resume/Restart, Option, Back To Main, Exit. Renders `AskToMoveNextLevel` when `showAskMenu`.
- `widget/ask_to_move_next_level.dart` — congratulation dialog (emoji-heavy) to proceed to next level or keep playing current.
- `widget/option_menu.dart` — AlertDialog: sound toggle, music toggle, color-theme dropdown (5 themes), Read Privacy Policy link (Google Sites URL).
- `widget/play_screen_widget/top_section.dart` — banner ad, Level title, `TimerLine` (play time + reward countdown + settings button), `ScoreLine` (target/score/high-score). Settings button toggles pause + opens menu.
- `widget/play_screen_widget/tap_to_play.dart` — full-screen "Tap to Play" overlay; first tap starts the game+clock.
- `widget/stage_icon.dart` — level tile in the grid; reads unlock state (`LevelController(stageId-1).getLevelState()`), Survival always enabled, locked tiles dimmed.
- `widget/main_menu_button.dart`, `gaf_button.dart`, `gaf_item.dart`, `gaf_text.dart`, `gaf_back_button.dart`, `gaf_rasid_button.dart`, `gaf_change_value_button.dart`, `gaf_dialog.dart`, `converted_icon.dart` (animated toggle icon), `snake_corner.dart`, `snake_eye.dart`, `stage_icon.dart`.

> Note: `widget/gaf_dialog.dart`'s `GafButtonDialog` has a broken button: `onPressed: () => onPressed` (passes a function returning a function). It appears unused. `GAFActionButton` in `gaf_package` is the working equivalent.

### GAF package (lib/gaf_package/)
- `gaf_service/ad_manager.dart` — AdMob **Ad unit IDs for Android** (`ca-app-pub-...`). Banner + rewarded IDs. `initAdMob()` is effectively a no-op stub.
- `gaf_service/app-update.dart` — fetches `version.json` from Firebase RTDB, parses MAJOR.MINOR.PATCH, compares against `KCurrentAppVersion`, shows `UpdateAppDialog` if outdated. **See Known Issues (broken `as Uri` cast + naive comparison).**
- `gaf_service/app-rating.dart` — after 20 launches (SharedPreferences counter) and not yet rated → `AppRatingDialog` → opens Play Store page. Sets `is_rate_done`.
- `gaf_service/open_google_play.dart` — launches `https://play.google.com/store/apps/details?id=com.gaf.classic_snake`.
- `gaf_widget/gaf_dialog.dart` — themed AlertDialog wrapper (title + divider + content + actions).
- `gaf_widget/gaf_dialog_action_button.dart` — "action + Cancel" row for dialogs.
- `gaf_widget/app_rating_dialog.dart`, `gaf_widget/app-update-Dialog.dart` — concrete dialogs built on the above.
- `ad_widget/banner_widget.dart` — `BannerAd`, keep-alive, 30s request throttle + 30s retry on failure.
- `ad_widget/rewarded_Ad.dart` — rewarded-ad helper. **Flawed (see Known Issues).**

---

## 7. Game Rules & Play Loop

### Board
- Fixed **30 rows × 20 columns = 600 cells**, single flat index `0..599` (index `0` = top-left; row = `index ~/ 20`; the left/right columns wrap; vertical wrap also implemented in Snake).
- `GameSize` singleton computes `cellSize` from the smaller screen dimension: `_cellSize = min(w,h) ~/ 20`; leftover is `_sideMargin`.

### Snake
- Starting body `[30, 50, 70, 90]`, starts moving `Down`, head = body.last (index 90).
- Movement is **toroidal**: off the top wraps to bottom, off left wraps to rightmost of same row-line logic (`helper/snake.dart:101-133`).
- Controlled by swipe anywhere on the play area: `PlayScreen.build`'s GestureDetector maps `onVerticalDragUpdate` / `onHorizontalDragUpdate` → `Direct.Up/Down/Left/Right`, forbidding a 180° reversal into the current direction.

### Main loop (`providers/stagePlay.dart`)
- `StagePlay.gamePlay()` starts `Timer.periodic(Duration(milliseconds: Manager.gameSpeed))` (default 300ms = `KDefaultGameSpeed`).
- Each tick (if not over/paused/speed-change): `snake.moving()` → `_isaLife()` (death check; grants one "Continue" via rewarded ad) → `_eating()` → `checkAvailabilityForSpecialFood()` → `notifyListeners()`.
- Eating:
  - Normal food → +`KEatScoreValue` (10), new food spawned, score/target/high-score checked.
  - Gift food → removed from `Manager.giftFoods`, +10.
  - Special food (`sFood`) → `Stage.eatingSFood()`: applies a random reward via `SpecialFood()`, starts reward countdown.
- Speed changes are handled by cancelling the timer and re-calling `gamePlay()` with the new duration.
- Target reached (score ≥ `level.targetScore`) → `LevelController.setLevelState()` unlocks the next level, plays `snaketargetdone.mp3`, and once (unless already asked) opens the "move to next level" prompt (`showAskMenu`), pausing the game. Survival (rank 0) and Custom (rank 999) skip this.
- High score → persisted via `LevelController.setLevelHighScore`, `snakehieghscorebreak.mp3` on first break.
- Death: `Manager.requestLife` set; if extra life already taken (`isExtraLifeTaken`) → game over. Otherwise pause + overlay "Continue" button → rewarded ad (watch → `giveExtraLife()` = IMMORTAL for 30s).

### Special food (`view_model/special_food.dart`)
Appears after a random **60–90s** delay, stays **15s** if uneaten. `getRandomReward()` uses `Random().nextInt(23)` weighted outcomes:

| Range | Reward | Effect |
|---|---|---|
| 0–1 | IMMORTAL | 30s invincible |
| 2 | Game Over | insta-death |
| 3–6 | Score Plus (10–209) | `+N` |
| 7–9 | Score Minus (−10..−209) | `−N` (score clamped ≥ 0) |
| 10–12 | More Food | spawns 10–29 gift foods (may overlap blocks — block check commented out) |
| 13–16 | Increase Speed | speed −(40..89)ms |
| 17–20 | Decrease Speed | speed +(40..89)ms |
| 21–23 | Change Color | snake turns blue (`isMustChangeSnakeColor`) for 15s |

`restReward()` (via `Stage.getRestTime()` 1s Timer) reverts speed/color/gift effects when the countdown ends, restoring `KDefaultGameSpeed`.

### Timer (separate from game loop)
`GameTimer` — independent 1s periodic timer for the displayed `HH:MM:SS` play time; starts on first tap, resets on game over.

---

## 8. Persistence (SharedPreferences keys)

| Key | Type | Owner | Meaning |
|---|---|---|---|
| `colorKey` | int | AppColorController | Theme index 0–4 |
| `soundState` | bool | GameSound | SFX on/off |
| `musicState` | bool | GameSound | music on/off |
| `stage_state{rank}` | bool | LevelController | level unlocked (rank 0 set true at splash) |
| `stage_high_score{rank}` | int | LevelController | personal best (>= 0) |
| `blocks_list{rank}` | String list | LevelController | custom level block indices (rank 999) |
| `level_target{rank}` | int | LevelController | custom level target (rank 999) |
| `count_app_run` | int | AppRating | launch counter for rating prompt |
| `is_rate_done` | bool | AppRating | rated → never ask again |

---

## 9. Known Issues / Technical Debt (verified by code reading)

1. **Broken widget test**: `test/widget_test.dart` is the untouched Flutter counter-template test; it pumps `MyApp()` and expects counter widgets that do not exist → it will fail. `integration_test/app_test.dart` and `driver.dart` are fully commented out. There are **no real tests** for game logic.
2. **AppUpdate cast bug**: `app-update.dart:17` does `http.get(_getVersion as Uri)` where `_getVersion` is a `String` → runtime `TypeError` (String is not Uri). Version-check dialog can never work / may throw unhandled async error whenever `StageScreen` builds.
3. **AppUpdate version compare bug**: `_haveLastVersion` compares components lexicographically (`last[i] <= current[i]` for each i) — wrong for e.g. `1.10.x` vs `2.0.x` mixed comparisons; fails to detect updates when a lower component is larger.
4. **Rewarded ad race (reward leak)**: `rewarded_Ad.dart` calls `_loadAd()` and immediately `_rewardedAd?.show(...)`; the ad is loaded asynchronously, so `show()` typically runs on a still-null ad, and `isLoad` is captured before the load callback fires (always `false` → always shows "No Ad Available" toast). **The reward callback runs on `onUserEarnedReward` from the shown ad; `runReward(context)` in `game_menu.dart` grants the extra life regardless of whether an ad actually completed** — i.e. reward can be claimed without a watched ad. Also the ad is re-created on every call without caching.
5. **Font family mismatch**: pubspec declares `family: Mail` but font files are `Mali-*` and `fontFamily: 'Mail'` is used → custom font silently never applies.
6. **Theme only partially applied**: `Cell`, `SnakeCorner`, `PlayScreen` scaffold, food/block/special-food colors are hardcoded RGB values; the 5-color theme changes chrome (backgrounds, fonts, menu) but not the playfield. `AppColor.playStageColor` (indexed by CellType) is computed but basically unused.
7. **Global mutable state everywhere**: `Manager` is a static grab-bag (flags, speed, score, snake, blocks, food…), heavily mutated from models/helpers/screens. Makes logic order-dependent and hard to test; several resets (`endGame`, `startGame`) must be kept in sync manually.
8. **Timer management fragility**: `gamePlay()` creates a fresh `Timer.periodic`; pause/resume/restart/speed-change paths re-create timers with cancel calls in multiple places (`stagePlay.dart:34-55`, `game_menu.dart`, `top_section.dart`), risking duplicate/ghost timers. Special-food spawn uses nested un-cancelled `Future.delayed`.
9. **Level/data coupling**: `levelList` is a mutable global; `DesignLevel` overwrites `levelList[31]` at runtime. `Position` model exists but the game mostly works on raw indices (blocks/snake as `List<int>`).
10. **Global `_dialogShow`** in `stages_screen.dart` is a file-level bool (not per-screen-instance): update+rating dialogs shown once per app lifetime by design.
11. **`RewardedHelperAd`/`toast` "No Ad Available"** is triggered even when the ad is genuinely loading (see #4) — creates a worse UX.
12. **Animal/flavor text**: `ask_to_move_next_level.dart` uses emoji in UI strings and a typo apostrophe `I'm` etc. App is **English-only** (RTL/Arabic not implemented despite skill guidelines — do not assume multilinguality).
13. `AppUpdate` uses HTTP endpoint `...firebaseio.com//version.json` (double slash) — fragile but the cast bug in #2 prevents it from working anyway.
14. `loading_screen.dart` is dead code (registered route, never navigated to).
15. **No secure upgrade path**: AdMob IDs and app/package IDs are hardcoded constants (fine for this project — do not "externalize" them into keys/config without being asked).

---

## 10. Code Conventions / Rules for This Repo

- **State management**: Provider only. `context.watch<StagePlay>()` / `read` / `Provider.of`. Root providers are `StagePlay`, `AppColorController`, `GameSound`.
- **Global state**: `Manager` static fields are the established (if imperfect) pattern — if changing state flow, keep every `Manager.*` read/write in sync across `stagePlay.dart`, `helper/*`, `view_model/*`, `game_menu.dart`, `tap_to_play.dart`, `top_section.dart`, `cell.dart`.
- **Screen size**: compute layout from `GameSize()` singleton (never raw `MediaQuery` except in a few places like `stages_screen.dart`). Top-level module globals like `double width = GameSize().width();` in screen/widget files are lazily initialized; they only work because `MyApp.build` calls `GameSize().calcGameSize(...)` early. Keep that initialization order intact.
- **Sounds**: play through `GameSound.playSoundEffect(K…Name)`; button clicks via `KButtonClick` in `GAFButton`/`GAFBackButton`/`MainMenuButton`/`GAFRaisedButton`/`GAFChangeValueButton`.
- **UI text**: custom `GAFText` with theme color + shadow; fonts sizes are screen-relative (`width * .04` style).
- **No comments unless asked; follow existing formatting** (2-space indent, single quotes, trailing commas).
- **Navigation**: named routes + `pushReplacementNamed` for game flow.
- **Do not add dependencies** unless a genuine gap exists (rules: prefer Flutter/Dart APIs; verify Dart ≤ 3.5.4 compatibility).
- **Testing**: before declaring a task done, add/run the smallest meaningful check. The repo currently lacks game-logic tests — adding unit tests for `Snake.move/eat/die`, `SpecialFood`, `LevelController`, or `StagePlay` ticks would be genuinely valuable (see Known Issues).
- Run `flutter analyze` before finishing; do not claim tests ran if they did not.

---

## 11. Sugggested Improvement Order (if asked to work on the project)

1. Fix the no-op/failing test files and add tiny unit tests for core logic (`Snake`, `SpecialFood`, `LevelController`, version comparison).
2. Fix `AppUpdate` `as Uri` cast and naive version compare.
3. Fix rewarded-ad flow (load → cache → show; only grant life inside `onUserEarnedReward` after a real ad).
4. Fix font family name (`Mail` → `Mali`) or remove the broken registration.
5. Consolidate timer creation/reset in `StagePlay` into one guarded lifecycle to avoid ghost timers.
6. Decide whether global `Manager` state → provider/state class refactor is warranted (bigger change, do not do unprompted).
7. Optionally apply the theme palette to playfield cells (currently hardcoded) if theme consistency is desired.

---

*End of project context. Generated from full source reading on 2026-09-11. Keep this document updated when the code changes significantly.*