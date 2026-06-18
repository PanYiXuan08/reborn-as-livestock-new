# Dog Family Prototype Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Godot 4.6.3 prototype for the dog-family vertical slice of Reborn as Livestock.

**Architecture:** A single `Main` Control builds the UI from code for fast prototype iteration. `GameState` owns run state, memories, wish, deviation, and act progression. Generated images live under `assets/ui_generated`; reference UI images are fallback assets.

**Tech Stack:** Godot 4.6.3, GDScript, JOJO OpenAI-compatible Image API with `gpt-image-2`.

---

### Task 1: Project Shell

**Files:**
- Create: `project.godot`
- Create: `main.tscn`
- Create: `autoload/game_state.gd`
- Create: `CONTEXT.md`

- [x] Create Godot project config with 1920x1080 canvas stretch.
- [x] Register `GameState` autoload.
- [x] Create `Main` Control scene.
- [x] Document project terms in `CONTEXT.md`.

### Task 2: Image Asset Pipeline

**Files:**
- Create: `tools/generate_ui_assets.ps1`
- Create: `tools/ui_asset_prompts.jsonl`
- Create: `assets/reference/*.png`

- [x] Copy UI design references into ASCII paths.
- [ ] Generate `gpt-image-2` assets when JOJO image channel is available.
- [ ] Save generated assets into `assets/ui_generated`.

### Task 3: Dog Loop UI

**Files:**
- Create: `main.gd`

- [ ] Build Home, Rebirth Wheel, Animal Select, Environment Select, Fate Deviation, Wish Board, Theater Stage, Fate Day, and Life Report screens.
- [ ] Use generated/reference images instead of pure color blocks.
- [ ] Record dog memories: `first_bite`, `first_wait`, `best_guard`, `best_track`, `last_sniff`, `last_approach`.

### Task 4: Verification

**Files:**
- Modify only if Godot check fails.

- [ ] Run `C:/Godot_v4.6.3/Godot_v4.6.3-stable_win64_console.exe --headless --path . --check-only --quit`.
- [ ] Fix all syntax or scene errors.
- [ ] Initialize git, commit, create/push GitHub repo `reborn-as-livestock-new`.

