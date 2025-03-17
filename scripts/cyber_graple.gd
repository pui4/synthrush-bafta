extends Node3D

@export var max_graple_distance : float
@export var graple_velocity : float
@export var graple_deadzone : float

@onready var graple_hook = $"Cube_001"
@onready var line = $"LineRenderer3D"
@onready var end_point = $"Cube_001/End point"
@onready var cooldown_timer = $"Cooldown"

@onready var hit_sfx = $"Cube_001/End point/Hit"
@onready var shoot_sfx = $"Shoot"
@onready var retract_sfx = $"Retract"

var graple_hook_orig_pos : Vector3
var graple_hook_orig_pos_global : Vector3
var point : Vector3
var object : Node3D
var can_grapple = true

func _ready() -> void:
	graple_hook_orig_pos = graple_hook.position
	graple_hook_orig_pos_global = graple_hook.global_position
	Lib.player_stop_retract.connect(_on_stop_retract)
	hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("use_cyber_hip") and Lib.player_raycast.is_colliding() and not Lib.player_raycast.get_collider().is_in_group("enemy") and not Lib.player_raycast.get_collider().is_in_group("player") and Lib.player_raycast.get_collision_point().distance_to(Lib.player_location) <= 100 and can_grapple and not Lib.soft_pause:
		show()
		point = Lib.player_raycast.get_collision_point()
		object = Lib.player_raycast.get_collider()
		graple_hook.reparent(get_tree().current_scene)
		graple_hook.set_layer_mask_value(2, false)
		graple_hook.set_layer_mask_value(1, true)
		shoot_sfx.play()
		cooldown_timer.start()
		can_grapple = false

	if point != Vector3.ZERO:
		graple_hook.global_position = graple_hook.global_position.move_toward(point, delta * graple_velocity)

		if graple_hook.global_position.distance_to(point) <= graple_deadzone:
			hit_sfx.play()
			#retract_sfx.play()
			Lib.start_player_graple.emit(point, object)
			graple_hook.global_position = point
			point = Vector3.ZERO

	line.points[0] = get_parent().global_position
	line.points[1] = end_point.global_position

	if Input.is_action_just_pressed("jump"):
		_on_stop_graple()

	if graple_hook.global_position.distance_to(Lib.player_location) <= 3 and round(graple_hook.global_position.direction_to(Lib.player_location)) == Vector3.DOWN:
		graple_hook.hide()
	else:
		graple_hook.show()

func _on_stop_graple() -> void:
	graple_hook.reparent(self)
	graple_hook.set_layer_mask_value(2, true)
	graple_hook.set_layer_mask_value(1, false)
	graple_hook.position = graple_hook_orig_pos
	graple_hook.rotation = Vector3.ZERO
	hide()
	shoot_sfx.stop()
	retract_sfx.stop()
	point = Vector3.ZERO
	Lib.stop_player_graple.emit()

func _on_stop_retract() -> void:
	retract_sfx.stop()
	shoot_sfx.stop()

func _on_cooldown_timeout() -> void:
	can_grapple = true