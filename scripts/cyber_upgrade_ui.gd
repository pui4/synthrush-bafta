extends Control

@export var item_icons : Dictionary

@export var panel_height : int
@export var increase : int

@onready var head_btn = $"Head"
@onready var arm_btn = $"Arm"
@onready var hip_btn = $"Hip"
@onready var leg_btn = $"Leg"
@onready var btns = [head_btn, arm_btn, hip_btn, leg_btn]

@onready var arm_panel = $"Arm panel"
@onready var hip_panel = $"Hip panel"
@onready var panels = [null, arm_panel, hip_panel, null]

@onready var click_sfx = $"Click"
@onready var apply_sfx = $"Apply"
@onready var blocker = $"Blocker"

var orig_panel_y : int
var current_panel = null

func _ready() -> void:
	var index = 0
	for i in Lib.unlocked_slots:
		if i:
			btns[index].get_node("TextureRect").hide()
			btns[index].disabled = false
		index += 1

func _on_save_pressed() -> void:
	apply_sfx.play()
	blocker.show()

func _on_leg_pressed() -> void:
	btn_pressed(3)
func _on_hip_pressed() -> void:
	btn_pressed(2)
func _on_arm_pressed() -> void:
	btn_pressed(1)
func _on_head_pressed() -> void:
	btn_pressed(0)

func btn_pressed(id : int) -> void:
	click_sfx.play()
	if current_panel == null:
		panels[id].visible = not panels[id].visible

		var children = panels[id].get_node("HBoxContainer").get_children()
		var index = 0
		for i in children:
			i.pressed.connect(menu_btn_pressed.bind(index))
			index += 1

		current_panel = id
	elif current_panel == id:
		panels[id].visible = not panels[id].visible
		current_panel = null

func menu_btn_pressed(id: int) -> void:
	click_sfx.play()
	var cat_name = ""
	match current_panel:
		2:
			cat_name = "hip"

	panels[current_panel].hide()
	Lib.current_player_cyber[cat_name] = id + 1
	btns[current_panel].icon = item_icons[cat_name][id]
	current_panel = null

func _on_apply_stopped() -> void:
	Lib.unpause()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()
