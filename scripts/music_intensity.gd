@tool
extends Node3D

@export var targetname: String = ""
@export var intensity: float

func _func_godot_apply_properties(props: Dictionary) -> void:
	targetname = props["targetname"] as String
	intensity = props["intesity"] as float
	
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	Lib.set_targetname(self, targetname)

func targetfunc() -> void:
	Lib.music_player.set_parameter("intensity", intensity)