@tool
extends Node3D

@export var targetname: String = ""
@export var id: int
@export var target : String = ""

func _func_godot_apply_properties(props: Dictionary) -> void:
	targetname = props["targetname"] as String
	id = props["wave_id"] as int
	target = props["target"] as String

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	Lib.set_targetname(self, targetname)

func targetfunc() -> void:
	Lib.start_wave(id, target)
	queue_free()