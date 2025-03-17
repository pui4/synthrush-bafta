extends Control

@export var panel_height : int
@export var increase : int

@onready var panel = $"Panel"

@onready var head_btn = $"Head"
@onready var arm_btn = $"Arm"
@onready var hip_btn = $"Hip"
@onready var leg_btn = $"Leg"
@onready var btns = [head_btn, arm_btn, hip_btn, leg_btn]

var orig_panel_y : int
var is_scaling = false

func _ready() -> void:
    orig_panel_y = panel.position.y

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
    panel.size.y = 0
    is_scaling = true

func _process(delta: float) -> void:
    if is_scaling:
        if panel.size.y < panel_height:
            panel.size.y += increase
            panel.position.y = orig_panel_y - panel.size.y / 4
        else:
            panel.size.y = panel_height
            panel.position.y = orig_panel_y - panel_height / 4