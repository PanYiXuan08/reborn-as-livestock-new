extends Control

const SCREEN_HOME := "home"
const SCREEN_WHEEL := "wheel"
const SCREEN_ANIMAL := "animal"
const SCREEN_ENVIRONMENT := "environment"
const SCREEN_DEVIATION := "deviation"
const SCREEN_WISH := "wish"
const SCREEN_THEATER := "theater"
const SCREEN_FATE := "fate"
const SCREEN_REPORT := "report"

const ACTS: Array[Dictionary] = [
	{
		"stage": "幼年期",
		"scene": "客厅",
		"line": "一只拖鞋躺在地上，比你大一点。",
		"asset": "theater_living_room.png",
		"actions": [
			{"text": "咬拖鞋", "id": "bite", "memory": "first_bite", "sentence": "它第一次咬住拖鞋时，整只狗都跟着晃了一下。"},
			{"text": "扑球", "id": "bite", "memory": "first_bite", "sentence": "它第一次扑向球，先摔倒，再摇尾巴。"},
			{"text": "闻饭碗", "id": "sniff", "memory": "first_smell", "sentence": "它记住了饭碗边缘那一点熟悉的味道。"},
		],
	},
	{
		"stage": "成长期",
		"scene": "玄关",
		"line": "门外有脚步声，你先闻到了。",
		"asset": "theater_entryway.png",
		"actions": [
			{"text": "等门", "id": "wait", "memory": "first_wait", "sentence": "它第一次坐在门边，等一个熟悉的人回来。"},
			{"text": "闻气味", "id": "sniff", "memory": "first_wait", "sentence": "它学会把门缝里的味道连成一条路。"},
			{"text": "贴门听", "id": "wait", "memory": "first_wait", "sentence": "它把耳朵贴在门上，世界变得很近。"},
		],
	},
	{
		"stage": "成年期",
		"scene": "家门",
		"line": "你已经知道谁是自己人。",
		"asset": "theater_entryway.png",
		"actions": [
			{"text": "甩头", "id": "bite", "memory": "best_shake", "sentence": "拖鞋飞了出去。它觉得这很合理。"},
			{"text": "守门", "id": "guard", "memory": "first_guard", "sentence": "它第一次把门当成自己的领地。"},
			{"text": "低吼", "id": "guard", "memory": "first_guard", "sentence": "门外的陌生味停了一下。"},
		],
	},
	{
		"stage": "成年期",
		"scene": "院子",
		"line": "陌生人停在门口，手里拿着东西。",
		"asset": "theater_entryway.png",
		"actions": [
			{"text": "护主", "id": "guard", "memory": "best_guard", "sentence": "它最用力的一次守护，让陌生人后退了三步。"},
			{"text": "追气味", "id": "track", "memory": "best_guard", "sentence": "它沿着气味绕过门口，确认家还在。"},
			{"text": "叼回玩具", "id": "bite", "memory": "best_guard", "sentence": "它把玩具叼回门边，像叼回一小块秩序。"},
		],
	},
	{
		"stage": "巅峰期",
		"scene": "雨夜街口",
		"line": "雨把气味冲散了，但你还记得方向。",
		"asset": "theater_rain_street.png",
		"actions": [
			{"text": "暴雨追踪", "id": "track", "memory": "best_track", "sentence": "它在雨里找到过一条几乎断掉的味道。"},
			{"text": "找气味", "id": "track", "memory": "best_track", "sentence": "鼻子比眼睛更早知道回家的方向。"},
			{"text": "奔跑", "id": "track", "memory": "best_track", "sentence": "那是它这一世跑得最快的一晚。"},
		],
	},
	{
		"stage": "衰退期",
		"scene": "旧鞋架",
		"line": "那只拖鞋还在，只是味道淡了。",
		"asset": "theater_old_shelf.png",
		"actions": [
			{"text": "慢闻旧拖鞋", "id": "sniff", "memory": "last_sniff", "sentence": "它最后一次闻旧拖鞋，味道淡得像一张旧照片。"},
			{"text": "慢走", "id": "wait", "memory": "last_sniff", "sentence": "路没有变远，是它走慢了。"},
			{"text": "等门", "id": "wait", "memory": "last_sniff", "sentence": "它又等了一会儿。门没有响。"},
		],
	},
	{
		"stage": "命运日",
		"scene": "门口昏光",
		"line": "那只手伸过来。你没有立刻扑上去。",
		"asset": "theater_fate_door.png",
		"actions": [
			{"text": "慢慢靠近", "id": "approach", "memory": "last_approach", "sentence": "最后，它慢慢靠近了那只手。"},
			{"text": "安静等着", "id": "approach", "memory": "last_approach", "sentence": "最后，它只是安静等着。"},
			{"text": "再闻一次旧拖鞋", "id": "sniff", "memory": "last_approach", "sentence": "最后，它又闻了一次旧拖鞋。"},
		],
	},
]

var _root: VBoxContainer
var _content: Control


func _ready() -> void:
	GameState.reset_game()
	GameState.changed.connect(_render)
	_build_shell()
	_render()


func _build_shell() -> void:
	_root = VBoxContainer.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_theme_constant_override("separation", 0)
	add_child(_root)

	_content = Control.new()
	_content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_root.add_child(_content)


func _render() -> void:
	for child in _content.get_children():
		child.queue_free()

	match GameState.screen:
		SCREEN_HOME:
			_render_home()
		SCREEN_WHEEL:
			_render_wheel()
		SCREEN_ANIMAL:
			_render_animal_select()
		SCREEN_ENVIRONMENT:
			_render_environment_select()
		SCREEN_DEVIATION:
			_render_deviation()
		SCREEN_WISH:
			_render_wish()
		SCREEN_THEATER:
			_render_theater()
		SCREEN_FATE:
			_render_fate()
		SCREEN_REPORT:
			_render_report()


func _render_home() -> void:
	_add_background("home_bg.png", "ui_flow_1.png")
	var panel := _paper_panel(Vector2(630, 140), Vector2(660, 690))
	_content.add_child(panel)
	_add_title(panel, "再投一胎", "动物人生重开模拟器")
	var button_x := (panel.size.x - 480.0) * 0.5
	_add_button_sized(panel, "开始投胎", Vector2(button_x, 270), Vector2(480, 72), func() -> void:
		GameState.set_screen(SCREEN_WHEEL)
	)
	_add_button_sized(panel, "生涯档案", Vector2(button_x, 360), Vector2(480, 72), func() -> void:
		_show_notice("生涯档案", "首版先验证狗线家养家庭，这里保留入口。")
	)
	_add_button_sized(panel, "命运图鉴", Vector2(button_x, 450), Vector2(480, 72), func() -> void:
		_show_notice("命运图鉴", "命运偏差和成长记忆会在后续版本沉淀到这里。")
	)
	_add_button_sized(panel, "设置", Vector2(button_x, 540), Vector2(480, 72), func() -> void:
		_show_notice("设置", "设置页占位。")
	)


func _render_wheel() -> void:
	_add_background("rebirth_wheel.png", "ui_flow_1.png")
	var panel := _paper_panel(Vector2(620, 120), Vector2(680, 790))
	_content.add_child(panel)
	_add_title(panel, "命运轮盘", "每一次投胎，都是一段会被记录的动物人生。")
	_add_body(panel, "动物：狗\n出生环境：家养家庭\n本能天赋：气味记忆\n命运偏差：待揭示", Vector2(90, 260), Vector2(500, 230), 28)
	_add_button(panel, "再投一胎", Vector2(180, 590), func() -> void:
		GameState.set_screen(SCREEN_ANIMAL)
	)


func _render_animal_select() -> void:
	_add_background("dog_card.png", "ui_flow_1.png")
	var title := _screen_title("选择动物", "首版只验证狗线。其他动物后续开放。")
	_content.add_child(title)
	var animals: Array[Dictionary] = [
		{"name": "猪", "sub": "用鼻子拱出一生", "enabled": false},
		{"name": "鸡", "sub": "在惊吓中啄食与逃生", "enabled": false},
		{"name": "鹅", "sub": "用脖子和翅膀守住领地", "enabled": false},
		{"name": "狗", "sub": "用气味记住世界", "enabled": true},
		{"name": "牛", "sub": "用身体承受牵引与劳作", "enabled": false},
	]
	for i in animals.size():
		var card := _selection_card(Vector2(170 + i * 330, 280), Vector2(280, 520), animals[i])
		_content.add_child(card)


func _render_environment_select() -> void:
	_add_background("family_home_card.png", "ui_flow_1.png")
	var title := _screen_title("选择出生环境", "家养家庭：拖鞋、门口、旧味道。")
	_content.add_child(title)
	var environments: Array[Dictionary] = [
		{"name": "农家院", "sub": "后续开放", "enabled": false},
		{"name": "城市纸箱", "sub": "后续开放", "enabled": false},
		{"name": "宠物家庭", "sub": "拖鞋、门口、旧味道", "enabled": true},
		{"name": "繁殖犬舍", "sub": "后续开放", "enabled": false},
		{"name": "训练犬舍", "sub": "后续开放", "enabled": false},
	]
	for i in environments.size():
		var card := _selection_card(Vector2(170 + i * 330, 280), Vector2(280, 520), environments[i])
		_content.add_child(card)


func _render_deviation() -> void:
	_add_background("fate_deviation_card.png", "ui_flow_2.png")
	var panel := _paper_panel(Vector2(460, 180), Vector2(1000, 620))
	_content.add_child(panel)
	_add_title(panel, "命运偏差", GameState.selected_deviation["title"])
	_add_body(panel, GameState.selected_deviation["body"], Vector2(120, 230), Vector2(760, 180), 30)
	_add_body(panel, "偏差不是废局，而是这一世不平整的开头。", Vector2(120, 420), Vector2(760, 90), 24)
	_add_button(panel, "接受这一世", Vector2(330, 500), func() -> void:
		GameState.set_screen(SCREEN_WISH)
	)


func _render_wish() -> void:
	_add_background("wish_board.png", "ui_flow_2.png")
	var panel := _paper_panel(Vector2(520, 130), Vector2(880, 780))
	_content.add_child(panel)
	_add_title(panel, "本局小愿望", "小愿望不是任务目标，而是这一生会反复出现的命运回声。")
	for i in GameState.WISHES.size():
		var wish := GameState.WISHES[i]
		_add_button(panel, wish, Vector2(145, 240 + i * 95), func() -> void:
			GameState.choose_wish(wish)
		)
	var start_button := _button("带着这个愿望开始")
	start_button.position = Vector2(220, 650)
	start_button.disabled = GameState.selected_wish == ""
	start_button.pressed.connect(func() -> void:
		GameState.set_screen(SCREEN_THEATER)
	)
	panel.add_child(start_button)


func _render_theater() -> void:
	var act := ACTS[GameState.act_index]
	_add_background(act["asset"], "ui_flow_2.png")
	_add_bookmark_bar()
	_add_status_bar()
	_add_stage_text(act)
	_add_action_bar(act, false)


func _render_fate() -> void:
	var act := ACTS[ACTS.size() - 1]
	_add_background(act["asset"], "ui_flow_2.png")
	_add_bookmark_bar()
	_add_status_bar()
	_add_stage_text(act)
	_add_action_bar(act, true)


func _render_report() -> void:
	_add_background("life_report_bg.png", "ui_flow_3.png")
	var panel := _paper_panel(Vector2(170, 90), Vector2(1580, 900))
	_content.add_child(panel)
	_add_title(panel, "动物生平报告", "这一世，它记住过一扇门。")

	var info_panel := _paper_panel(Vector2(80, 230), Vector2(400, 250))
	panel.add_child(info_panel)
	_add_body(info_panel, "本世档案", Vector2(28, 24), Vector2(340, 38), 30)
	_add_body(info_panel, "动物：狗\n出生环境：家养家庭\n命运偏差：%s\n本局小愿望：%s" % [
		GameState.selected_deviation["title"],
		GameState.selected_wish,
	], Vector2(28, 82), Vector2(340, 130), 24)

	var memory_panel := _paper_panel(Vector2(520, 230), Vector2(620, 520))
	panel.add_child(memory_panel)
	_add_body(memory_panel, "成长记忆", Vector2(34, 28), Vector2(520, 42), 32)
	_add_body(memory_panel, _format_memories(), Vector2(34, 94), Vector2(540, 360), 23)

	var stats_panel := _paper_panel(Vector2(1180, 230), Vector2(320, 360))
	panel.add_child(stats_panel)
	_add_body(stats_panel, "行为统计", Vector2(28, 28), Vector2(250, 42), 32)
	_add_body(stats_panel, "咬 / 甩：%d\n等门：%d\n守门：%d\n追踪：%d\n闻/嗅：%d\n慢靠近：%d" % [
		int(GameState.stats.get("bite", 0)),
		int(GameState.stats.get("wait", 0)),
		int(GameState.stats.get("guard", 0)),
		int(GameState.stats.get("track", 0)),
		int(GameState.stats.get("sniff", 0)),
		int(GameState.stats.get("approach", 0)),
	], Vector2(28, 92), Vector2(250, 210), 24)

	var final_panel := _paper_panel(Vector2(80, 790), Vector2(1060, 72))
	panel.add_child(final_panel)
	_add_body(final_panel, "最后一句：%s" % str(
		GameState.memories.get("last_approach", "它安静地走完了这一世。")
	), Vector2(28, 18), Vector2(990, 34), 24)

	_add_button_sized(panel, "再投一胎", Vector2(1180, 790), Vector2(320, 72), func() -> void:
		GameState.reset_game()
	)


func _add_background(generated_name: String, fallback_name: String) -> void:
	var texture := _load_texture("res://assets/ui_generated/" + generated_name)
	if texture == null:
		texture = _load_texture("res://assets/reference/" + fallback_name)
	var rect := TextureRect.new()
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.texture = texture
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	_content.add_child(rect)

	var wash := ColorRect.new()
	wash.set_anchors_preset(Control.PRESET_FULL_RECT)
	wash.color = Color(0.96, 0.92, 0.84, 0.20)
	_content.add_child(wash)


func _load_texture(path: String) -> Texture2D:
	if not ResourceLoader.exists(path):
		return null
	return load(path) as Texture2D


func _paper_panel(position: Vector2, size: Vector2) -> Panel:
	var panel := Panel.new()
	panel.position = position
	panel.custom_minimum_size = size
	panel.size = size
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.90, 0.86, 0.76, 0.90)
	style.border_color = Color(0.12, 0.11, 0.10, 0.85)
	style.set_border_width_all(3)
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	panel.add_theme_stylebox_override("panel", style)
	return panel


func _add_title(parent: Control, title: String, subtitle: String) -> void:
	var title_label := Label.new()
	title_label.text = title
	title_label.position = Vector2(60, 50)
	title_label.size = Vector2(parent.size.x - 120, 90)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 58)
	title_label.add_theme_color_override("font_color", Color(0.06, 0.055, 0.05))
	parent.add_child(title_label)

	var sub_label := Label.new()
	sub_label.text = subtitle
	sub_label.position = Vector2(70, 145)
	sub_label.size = Vector2(parent.size.x - 140, 80)
	sub_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	sub_label.add_theme_font_size_override("font_size", 24)
	sub_label.add_theme_color_override("font_color", Color(0.12, 0.11, 0.10))
	parent.add_child(sub_label)


func _screen_title(title: String, subtitle: String) -> Panel:
	var panel := _paper_panel(Vector2(520, 70), Vector2(880, 150))
	_add_title(panel, title, subtitle)
	return panel


func _add_body(parent: Control, text: String, position: Vector2, size: Vector2, font_size: int) -> void:
	var label := Label.new()
	label.text = text
	label.position = position
	label.size = size
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color(0.07, 0.065, 0.06))
	parent.add_child(label)


func _button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(440, 72)
	button.add_theme_font_size_override("font_size", 30)
	return button


func _add_button_sized(parent: Control, text: String, position: Vector2, size: Vector2, callable: Callable) -> void:
	var button := _button(text)
	button.position = position
	button.custom_minimum_size = size
	button.size = size
	button.pressed.connect(callable)
	parent.add_child(button)

func _add_button(parent: Control, text: String, position: Vector2, callable: Callable) -> void:
	var button := _button(text)
	button.position = position
	button.pressed.connect(callable)
	parent.add_child(button)


func _selection_card(position: Vector2, size: Vector2, data: Dictionary) -> Panel:
	var card := _paper_panel(position, size)
	var name_label := Label.new()
	name_label.text = data["name"]
	name_label.position = Vector2(40, 60)
	name_label.size = Vector2(size.x - 80, 70)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 48)
	card.add_child(name_label)

	var sub_label := Label.new()
	sub_label.text = data["sub"]
	sub_label.position = Vector2(35, 160)
	sub_label.size = Vector2(size.x - 70, 160)
	sub_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	sub_label.add_theme_font_size_override("font_size", 24)
	card.add_child(sub_label)

	var button := _button("选择" if data["enabled"] else "后续开放")
	button.position = Vector2(35, 390)
	button.custom_minimum_size = Vector2(size.x - 70, 70)
	button.disabled = not data["enabled"]
	button.pressed.connect(func() -> void:
		if GameState.screen == SCREEN_ANIMAL:
			GameState.set_screen(SCREEN_ENVIRONMENT)
		else:
			GameState.set_screen(SCREEN_DEVIATION)
	)
	card.add_child(button)
	return card


func _add_bookmark_bar() -> void:
	var bar := HBoxContainer.new()
	bar.position = Vector2(120, 30)
	bar.size = Vector2(1680, 70)
	bar.add_theme_constant_override("separation", 12)
	_content.add_child(bar)
	for stage in GameState.STAGES:
		var label := Label.new()
		label.text = stage
		label.custom_minimum_size = Vector2(260, 60)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 28)
		if stage == GameState.current_stage():
			label.add_theme_color_override("font_color", Color(0.02, 0.02, 0.02))
		else:
			label.add_theme_color_override("font_color", Color(0.35, 0.33, 0.30))
		bar.add_child(label)


func _add_status_bar() -> void:
	var panel := _paper_panel(Vector2(120, 110), Vector2(1680, 80))
	_content.add_child(panel)
	var status := "幕次：%d/7    环境：家养家庭    愿望：%s    偏差：%s" % [
		min(GameState.act_index + 1, 7),
		GameState.selected_wish,
		GameState.selected_deviation["title"],
	]
	_add_body(panel, status, Vector2(40, 20), Vector2(1600, 45), 26)


func _add_stage_text(act: Dictionary) -> void:
	var panel := _paper_panel(Vector2(210, 740), Vector2(1500, 250))
	_content.add_child(panel)
	_add_body(panel, "%s · %s\n%s" % [act["stage"], act["scene"], act["line"]], Vector2(60, 35), Vector2(1380, 120), 34)


func _add_action_bar(act: Dictionary, fate_mode: bool) -> void:
	var actions: Array = act["actions"]
	for i in actions.size():
		var action: Dictionary = actions[i]
		var button := _button(action["text"])
		button.position = Vector2(330 + i * 460, 910)
		button.custom_minimum_size = Vector2(360, 70)
		button.pressed.connect(func() -> void:
			GameState.record_action(action["id"], action["memory"], action["sentence"])
			if fate_mode:
				GameState.set_screen(SCREEN_REPORT)
			else:
				GameState.advance_act()
				if GameState.act_index >= 6:
					GameState.set_screen(SCREEN_FATE)
				else:
					GameState.set_screen(SCREEN_THEATER)
		)
		_content.add_child(button)


func _format_memories() -> String:
	if GameState.memories.is_empty():
		return "还没有被记录的成长记忆。"
	var lines: Array[String] = []
	for key in GameState.memories.keys():
		lines.append("- %s" % GameState.memories[key])
	return "\n".join(lines)


func _show_notice(title: String, body: String) -> void:
	var panel := _paper_panel(Vector2(610, 300), Vector2(700, 360))
	_content.add_child(panel)
	_add_title(panel, title, body)
	_add_button(panel, "关闭", Vector2(130, 240), func() -> void:
		panel.queue_free()
	)
