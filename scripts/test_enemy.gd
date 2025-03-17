@tool
extends Node3D

@export var health = 100
@export var func_godot_properties : Dictionary

func _process(delta: float) -> void:
    if Engine.is_editor_hint():
        return
    if health <= 0:
        queue_free()