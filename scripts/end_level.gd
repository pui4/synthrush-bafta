@tool
extends Node3D

@export var targetname: String = ""
@export var level: String

func _func_godot_apply_properties(props: Dictionary) -> void:
	targetname = props["targetname"] as String
	level = props["level"] as String

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	Lib.set_targetname(self, targetname)

func targetfunc() -> void:
	print("yello")
	var lev = load("res://maps/ending.tscn")
	var leve = lev.instantiate()
	get_tree().root.add_child(leve)
	get_tree().root.get_node("arena").queue_free()
	get_tree().current_scene = leve
