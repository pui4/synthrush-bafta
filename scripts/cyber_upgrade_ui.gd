extends Control

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

var orig_panel_y : int

func _ready() -> void:
	var index = 0
	for i in Lib.unlocked_slots:
		if i:
			btns[index].get_node("TextureRect").hide()
			btns[index].disabled = false
		index += 1

func _on_save_pressed() -> void:
	Lib.unpause()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()

func _on_leg_pressed() -> void:
	btn_pressed(3)
func _on_hip_pressed() -> void:
	btn_pressed(2)
func _on_arm_pressed() -> void:
	btn_pressed(1)
func _on_head_pressed() -> void:
	btn_pressed(0)

func btn_pressed(id : int) -> void:
	panels[id].visible = not panels[id].visible
	var children = panels[id].get_node("HBoxContainer").get_children()
	for i in children:
		print(i)
