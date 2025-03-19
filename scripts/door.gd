@tool
extends StaticBody3D

var buffer : float = 1
var speed : float = 0.1

@export var targetname : String

var height : float
var is_moving_up : bool = false
var orig_y : float

func _func_godot_apply_properties(props: Dictionary) -> void:
    targetname = props["targetname"] as String

func _ready() -> void:
    if Engine.is_editor_hint():
        return
    Lib.set_targetname(self, targetname)

    for i in get_children():
        if i is MeshInstance3D:
            height = i.get_aabb().size.y
        
    orig_y = position.y

func targetfunc() -> void:
    is_moving_up = true

func _process(_delta: float) -> void:
    if Engine.is_editor_hint():
        return

    if is_moving_up:
        if position.y - orig_y - height < -buffer:
            position.y += speed
        else:
            position.y = height + orig_y - buffer
            await get_tree().create_timer(1).timeout
            is_moving_up = false
    else:
        if position.y > orig_y:
            position.y -= speed
        else:
            position.y = orig_y