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

Current blocker: JOJO returns `503 model_not_found` with `No available channel for model gpt-image-2 under group CodexPlus`, even though the model list includes `gpt-image-2`.

