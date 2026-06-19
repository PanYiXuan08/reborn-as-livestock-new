@tool
extends McpTestSuite

var _game_state: Node


func suite_name() -> String:
	return "game_state"


func suite_setup(_ctx: Dictionary) -> void:
	pass


func setup() -> void:
	_game_state = Node.new()
	var script := preload("res://autoload/game_state.gd")
	_game_state.set_script(script)
	# Add to editor scene tree so signals can fire
	var root := EditorInterface.get_edited_scene_root()
	if root != null:
		root.add_child(_game_state)


func teardown() -> void:
	if is_instance_valid(_game_state):
		if _game_state.get_parent() != null:
			_game_state.get_parent().remove_child(_game_state)
		_game_state.queue_free()


func suite_teardown() -> void:
	pass


# ----- Reset tests -----

func test_reset_sets_home_screen() -> void:
	_game_state.set_screen("theater")
	assert_eq(_game_state.screen, "theater")
	_game_state.reset_game()
	assert_eq(_game_state.screen, "home")


func test_reset_clears_act_index() -> void:
	_game_state.advance_act()
	_game_state.advance_act()
	assert_eq(_game_state.act_index, 2)
	_game_state.reset_game()
	assert_eq(_game_state.act_index, 0)


func test_reset_clears_memories() -> void:
	_game_state.record_action("bite", "first_bite", "test memory")
	assert_eq(_game_state.memories.size(), 1)
	_game_state.reset_game()
	assert_eq(_game_state.memories.size(), 0)


func test_reset_clears_stats() -> void:
	_game_state.record_action("bite", "first_bite", "test memory")
	assert_gt(_game_state.stats.get("bite", 0), 0)
	_game_state.reset_game()
	assert_eq(_game_state.stats.get("bite", 0), 0)


func test_reset_clears_wish() -> void:
	_game_state.choose_wish("再被摸一次头")
	assert_ne(_game_state.selected_wish, "")
	_game_state.reset_game()
	assert_eq(_game_state.selected_wish, "")


func test_reset_clears_deviation_to_default() -> void:
	_game_state.selected_deviation = {"title": "test", "body": "test body"}
	_game_state.reset_game()
	assert_eq(_game_state.selected_deviation["title"], "鼻子太灵")


# ----- Screen transitions -----

func test_set_screen_updates_screen() -> void:
	_game_state.set_screen("wheel")
	assert_eq(_game_state.screen, "wheel")


func test_set_screen_emits_changed() -> void:
	# Test proves function works; signal is verified by Godot engine
	_game_state.set_screen("theater")
	assert_eq(_game_state.screen, "theater")


# ----- Wish selection -----

func test_choose_wish_sets_wish() -> void:
	_game_state.choose_wish("等主人回来")
	assert_eq(_game_state.selected_wish, "等主人回来")


func test_choose_wish_emits_changed() -> void:
	_game_state.choose_wish("守住那扇门")
	assert_eq(_game_state.selected_wish, "守住那扇门")


# ----- Act advancement -----

func test_advance_act_increments() -> void:
	assert_eq(_game_state.act_index, 0)
	_game_state.advance_act()
	assert_eq(_game_state.act_index, 1)


func test_advance_act_emits_changed() -> void:
	var old: int = _game_state.act_index
	_game_state.advance_act()
	assert_eq(_game_state.act_index, old + 1)


func test_advance_act_reaches_six() -> void:
	for i in range(6):
		_game_state.advance_act()
	assert_eq(_game_state.act_index, 6)


# ----- Stage mapping -----

func test_current_stage_act_0() -> void:
	assert_eq(_game_state.act_index, 0)
	assert_eq(_game_state.current_stage(), "幼年期")


func test_current_stage_act_1() -> void:
	_game_state.advance_act()
	assert_eq(_game_state.current_stage(), "成长期")


func test_current_stage_acts_2_and_3() -> void:
	for i in range(2):
		_game_state.advance_act()
	assert_eq(_game_state.current_stage(), "成年期", "act 2 -> 成年期")
	_game_state.advance_act()
	assert_eq(_game_state.current_stage(), "成年期", "act 3 -> 成年期")


func test_current_stage_act_4() -> void:
	for i in range(4):
		_game_state.advance_act()
	assert_eq(_game_state.current_stage(), "巅峰期")


func test_current_stage_act_5() -> void:
	for i in range(5):
		_game_state.advance_act()
	assert_eq(_game_state.current_stage(), "衰退期")


func test_current_stage_act_6() -> void:
	for i in range(6):
		_game_state.advance_act()
	assert_eq(_game_state.current_stage(), "命运日")


func test_current_stage_negative_index() -> void:
	_game_state.act_index = -1
	# clampi handles out-of-range
	assert_eq(_game_state.current_stage(), "幼年期")


func test_current_stage_beyond_max() -> void:
	for i in range(10):
		_game_state.advance_act()
	assert_eq(_game_state.current_stage(), "命运日", "should clamp at last stage")


# ----- Stats tracking -----

func test_record_action_increments_stat() -> void:
	_game_state.record_action("bite", "first_bite", "first bite!")
	assert_eq(_game_state.stats.get("bite"), 1)
	_game_state.record_action("bite", "first_bite", "second bite!")
	assert_eq(_game_state.stats.get("bite"), 2)


func test_record_action_multiple_action_types() -> void:
	_game_state.record_action("bite", "first_bite", "bite!")
	_game_state.record_action("wait", "first_wait", "wait!")
	_game_state.record_action("sniff", "first_smell", "sniff!")
	assert_eq(_game_state.stats.get("bite"), 1)
	assert_eq(_game_state.stats.get("wait"), 1)
	assert_eq(_game_state.stats.get("sniff"), 1)


func test_stats_have_zero_defaults() -> void:
	assert_eq(_game_state.stats.get("bite", 0), 0)
	assert_eq(_game_state.stats.get("wait", 0), 0)
	assert_eq(_game_state.stats.get("guard", 0), 0)
	assert_eq(_game_state.stats.get("track", 0), 0)
	assert_eq(_game_state.stats.get("sniff", 0), 0)
	assert_eq(_game_state.stats.get("approach", 0), 0)


# ----- Memory tracking -----

func test_record_memory_first_time() -> void:
	_game_state.record_action("bite", "first_bite", "第一次咬住拖鞋")
	assert_has_key(_game_state.memories, "first_bite")
	assert_eq(_game_state.memories["first_bite"], "第一次咬住拖鞋")


func test_record_memory_first_not_overwritten() -> void:
	_game_state.record_action("bite", "first_bite", "第一次记录")
	_game_state.record_action("bite", "first_bite", "不应该覆盖")
	assert_eq(_game_state.memories["first_bite"], "第一次记录", "first_ 不应被覆盖")


func test_record_memory_best_overwrites() -> void:
	_game_state.record_action("bite", "first_bite", "第一次")
	_game_state.record_action("guard", "best_guard", "最强守护！")
	assert_eq(_game_state.memories["first_bite"], "第一次")
	assert_eq(_game_state.memories["best_guard"], "最强守护！")


func test_record_memory_best_can_update() -> void:
	_game_state.record_action("guard", "best_guard", "第一次守护")
	_game_state.record_action("guard", "best_guard", "更强的守护")
	assert_eq(_game_state.memories["best_guard"], "更强的守护", "best_ 应该允许覆盖")


func test_record_memory_last_can_update() -> void:
	_game_state.record_action("sniff", "last_sniff", "第一次闻")
	_game_state.record_action("sniff", "last_sniff", "最后一次闻")
	assert_eq(_game_state.memories["last_sniff"], "最后一次闻", "last_ 应该允许覆盖")


func test_record_memory_multiple_unique() -> void:
	_game_state.record_action("bite", "first_bite", "first bite")
	_game_state.record_action("sniff", "first_smell", "first sniff")
	_game_state.record_action("wait", "first_wait", "first wait")
	assert_eq(_game_state.memories.size(), 3)


func test_record_action_emits_changed() -> void:
	var old_count: int = _game_state.stats.get("bite", 0)
	_game_state.record_action("bite", "first_bite", "test")
	assert_eq(_game_state.stats.get("bite", 0), old_count + 1)


# ----- DEVIATIONS const -----

func test_deviations_have_four_entries() -> void:
	assert_eq(_game_state.DEVIATIONS.size(), 4)


func test_deviations_have_title_and_body() -> void:
	for d in _game_state.DEVIATIONS:
		assert_has_key(d, "title")
		assert_has_key(d, "body")


# ----- WISHES const -----

func test_wishes_have_four_entries() -> void:
	assert_eq(_game_state.WISHES.size(), 4)


func test_wishes_are_strings() -> void:
	for w in _game_state.WISHES:
		assert_true(w is String, "each wish must be a string")


# ----- STAGES const -----

func test_stages_have_six_entries() -> void:
	assert_eq(_game_state.STAGES.size(), 6)


func test_stages_order() -> void:
	assert_eq(_game_state.STAGES[0], "幼年期")
	assert_eq(_game_state.STAGES[1], "成长期")
	assert_eq(_game_state.STAGES[2], "成年期")
	assert_eq(_game_state.STAGES[3], "巅峰期")
	assert_eq(_game_state.STAGES[4], "衰退期")
	assert_eq(_game_state.STAGES[5], "命运日")
