@tool
extends Node3D

@export var tar_id: int
@export var target : String = ""

func _func_godot_apply_properties(props: Dictionary) -> void:
	tar_id = props["wave_id"] as int
	target = props["target"] as String

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	Lib.wave_done.connect(_on_wave_done)

func _on_wave_done(id : int) -> void:
	if id == tar_id:
		Lib.use_targets(target)
		queue_free()