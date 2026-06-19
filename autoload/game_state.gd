@tool
extends Node

signal changed

const STAGES: Array[String] = [
	"幼年期",
	"成长期",
	"成年期",
	"巅峰期",
	"衰退期",
	"命运日",
]

const WISHES: Array[String] = [
	"再被摸一次头",
	"找回家的气味",
	"等主人回来",
	"守住那扇门",
]

const DEVIATIONS: Array[Dictionary] = [
	{
		"title": "鼻子太灵",
		"body": "嗅觉范围更大，但陌生气味也更容易把你带偏。",
	},
	{
		"title": "胆小",
		"body": "面对陌生事物会更慢，但熟悉气味会被记得更久。",
	},
	{
		"title": "后腿旧伤",
		"body": "奔跑反馈变弱，命运日的慢靠近会更安静。",
	},
	{
		"title": "听力偏差",
		"body": "门铃和脚步声会变模糊，你更依赖气味。",
	},
]

var screen: String = "home"
var act_index: int = 0
var selected_wish: String = ""
var selected_deviation: Dictionary = DEVIATIONS[0]
var memories: Dictionary = {}
var stats: Dictionary = {}


func reset_game() -> void:
	screen = "home"
	act_index = 0
	selected_wish = ""
	selected_deviation = DEVIATIONS[0]
	memories = {}
	stats = {
		"bite": 0,
		"wait": 0,
		"guard": 0,
		"track": 0,
		"sniff": 0,
		"approach": 0,
	}
	changed.emit()


func set_screen(next_screen: String) -> void:
	screen = next_screen
	changed.emit()


func choose_wish(wish: String) -> void:
	selected_wish = wish
	changed.emit()


func record_action(action_id: String, memory_key: String, memory_sentence: String) -> void:
	stats[action_id] = int(stats.get(action_id, 0)) + 1
	if not memories.has(memory_key) or _should_overwrite(memory_key):
		memories[memory_key] = memory_sentence
	changed.emit()


func _should_overwrite(key: String) -> bool:
	return key.begins_with("best_") or key.begins_with("last_")


func advance_act() -> void:
	act_index += 1
	changed.emit()


func current_stage() -> String:
	# 7 acts (0-6) map to 6 stages: act 2 and 3 both map to "成年期"
	var stage_map := [0, 1, 2, 2, 3, 4, 5]
	var idx := clampi(act_index, 0, stage_map.size() - 1)
	return STAGES[stage_map[idx]]

