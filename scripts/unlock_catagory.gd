@tool
extends Node3D

@export var targetname: String = ""
@export var id: int

func _func_godot_apply_properties(props: Dictionary) -> void:
	targetname = props["targetname"] as String
	id = props["id"] as int

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	Lib.set_targetname(self, targetname)

func targetfunc() -> void:
	Lib.unlocked_slots[id] = true