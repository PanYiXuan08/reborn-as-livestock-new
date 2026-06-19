# Code Review Report — 2026-06-19

## Scope

- `autoload/game_state.gd` — Game state singleton
- `main.gd` — Main game UI controller

## Findings

### P0-1: 生平报告缺少"嗅/闻"统计

**File**: `main.gd` — `_render_report()`  
**Issue**: 统计面板只显示 "咬/甩""等门""守门""追踪""慢靠近" 五类，缺少 `sniff`（闻/嗅）计数。  
**Impact**: 游戏中有闻饭碗、闻气味、闻拖鞋等交互动作，但报告卡无法反映这些行为。  
**Fix**: 在统计面板中添加 "闻/嗅：%d"。

### P0-2: `_render_fate()` 硬编码 ACTS[6]

**File**: `main.gd` — `_render_fate()`  
**Issue**: `var act := ACTS[6]` 直接写死索引 6。  
**Impact**: 如果 ACTS 数组增减条目，命运日画面会引用错误数据或越界。  
**Fix**: 使用 `ACTS[ACTS.size() - 1]` 替代硬编码索引。

### P1-1: `record_action` 的记忆覆盖策略可读性低

**File**: `game_state.gd` — `record_action()`  
**Issue**: 已存在记忆时仅 best_/last_ 前缀允许覆盖，逻辑嵌套较深且第一遍不易理解。  
**Impact**: 可维护性，新开发者需仔细推敲覆盖条件。  
**Fix**: 提取为 `_should_overwrite(key: String) -> bool` 辅助函数。

### P2-1: `current_stage()` 使用 if-else 链

**File**: `game_state.gd` — `current_stage()`  
**Issue**: 7 个 act_index 到 6 个 stage 的映射用 if-else 实现。  
**Impact**: 可维护性，未来如要合并更多 stage 需要修改多行。  
**Fix**: 重构为索引映射表。

### P3-1: STAGES 与 ACTS 数量不一致

**File**: `main.gd` (ACTS=7) vs `game_state.gd` (STAGES=6)  
**Note**: 当前通过 `current_stage()` 的 if-else 链将 7 个 act 映射到 6 个 stage（成年期有两个 act）。这是设计决策，但建议加注释说明以避免后续维护者困惑。

## Priority Summary

| ID | Severity | Status |
|----|----------|--------|
| P0-1 | 阻塞 | 待修复 |
| P0-2 | 阻塞 | 待修复 |
| P1-1 | 强烈建议 | 待修复 |
| P2-1 | 建议 | 待修复 |
| P3-1 | 可选 | 已记录 |
