extends Node3D

@export var max_interact_dist : float
@export var max_look_dist : float

@onready var head = $"dealer"
@onready var mouth = $"dealer/Mouth"
@onready var anim = $"dealer/AnimationPlayer"

var ui = preload("res://ui/cyber_upgrade_ui.tscn")

func _ready() -> void:
    Dialogic.signal_event.connect(_on_dialogic_signal)
    Dialogic.state_changed.connect(_on_state_change)

func _process(delta: float) -> void:
    if Lib.player_location.distance_to(global_position) <= max_look_dist:
        head.look_at(Lib.player.get_node("Head").global_position)
        head.rotation_degrees.y -= 90
        head.rotation.z = -head.rotation.x
        head.rotation.x = 0

    if Lib.player_raycast.is_colliding() and Lib.player_raycast.get_collider().get_parent() == self and Lib.player_location.distance_to(global_position) <= max_interact_dist and Input.is_action_just_pressed("use") and not Lib.soft_pause:
        Dialogic.VAR.set("rnd_msg", randi_range(1, 4))
        Dialogic.start('timeline')

func _on_dialogic_signal(argument:String):
    if argument == "dealer_done":
        var ui_inst = ui.instantiate()
        get_tree().root.add_child(ui_inst)
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        Lib.pause()

var prev_state : int
func _on_state_change(state: Dialogic.States) -> void:
    print(state)
    if state == 2:
        anim.play("talk")
    elif state == 0 and prev_state == 1:
        anim.stop()
    prev_state = state