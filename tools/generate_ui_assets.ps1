$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$KeyPath = "C:\Pi\APIkey.md"
$ImageGen = "C:\Users\Administrator\.codex\skills\.system\imagegen\scripts\image_gen.py"
$PromptFile = Join-Path $PSScriptRoot "ui_asset_prompts.jsonl"
$OutDir = Join-Path $ProjectRoot "assets\ui_generated"

if (-not (Test-Path $KeyPath)) {
    throw "Missing API key file: $KeyPath"
}

New-Item -ItemType Directory -Force $OutDir | Out-Null

$env:OPENAI_API_KEY = (Get-Content -Raw $KeyPath).Trim()
$env:OPENAI_BASE_URL = "https://api2.jojocode.com/v1"

py -3.14 $ImageGen generate-batch `
    --input $PromptFile `
    --out-dir $OutDir `
    --concurrency 2 `
    --force

