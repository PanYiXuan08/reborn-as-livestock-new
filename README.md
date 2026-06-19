# Reborn as Livestock New

Godot 4.6.3 prototype for `再投一胎：动物人生重开模拟器`.

## Scope

- Vertical slice: dog line, family home.
- Flow: home -> rebirth wheel -> animal select -> environment select -> fate deviation -> wish board -> seven-act theater -> life report.
- UI direction: old dossier, black-and-white storybook, aged paper, archive stamps.
- Generated image assets belong in `assets/ui_generated`.
- Reference UI images live in `assets/reference` and are used as fallback visuals until generated assets are available.

## Run

```powershell
C:\Godot_v4.6.3\Godot_v4.6.3-stable_win64.exe --path C:\Pi\reborn-as-livestock-new
```

## Check

```powershell
C:\Godot_v4.6.3\Godot_v4.6.3-stable_win64_console.exe --headless --path C:\Pi\reborn-as-livestock-new --check-only --quit
```

## Generate UI Assets

`tools/generate_ui_assets.ps1` reads the API key from `C:\Pi\APIkey.md` and calls JOJO's OpenAI-compatible image API:

- Base URL: `https://api2.jojocode.com/v1`
- Model: `gpt-image-2`
- Prompts: `tools/ui_asset_prompts.jsonl`
- Output: `assets/ui_generated`

13 assets generated on 2026-06-18 (dog_card, dog_life_stages, family_home_card, fate_deviation_card, home_bg, life_report_bg, rebirth_wheel, theater_entryway, theater_fate_door, theater_living_room, theater_old_shelf, theater_rain_street, wish_board). All committed to repo.

To re-run generation:

```powershell
pwsh -File tools\generate_ui_assets.ps1
```

Note: `.import` files are gitignored (`*.import`) — Godot regenerates them on project open. UID mappings are preserved in the `.godot/` cache.


