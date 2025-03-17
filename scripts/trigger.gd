@tool
extends Area3D

@export var target: String = ""
@export var fireonce: bool

func _func_godot_apply_properties(props: Dictionary) -> void:
    target = props["target"] as String
    fireonce = props["fireonce"] as bool

func _ready() -> void:
    body_entered.connect(_on_body_enter)

func _on_body_enter(body: Node3D) -> void:
    if (body.is_in_group("player")):
        Lib.use_targets(target)
        if fireonce: queue_free()