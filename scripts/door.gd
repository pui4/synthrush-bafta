@tool
extends StaticBody3D

var buffer : float = 1
var speed : float = 0.1

@export var targetname : String
@export var autoclose : bool

var height : float
var is_moving_up : bool = false
var orig_y : float

var door_sfx : FmodEventEmitter3D
var stop_sfx : FmodEventEmitter3D
var stop_sfx_has_played : bool = true
var door_sfx_has_played : bool = false

func _func_godot_apply_properties(props: Dictionary) -> void:
    targetname = props["targetname"] as String
    autoclose = props["autoclose"] as bool

func _ready() -> void:
    if Engine.is_editor_hint():
        return
    Lib.set_targetname(self, targetname)

    for i in get_children():
        if i is MeshInstance3D:
            height = i.get_aabb().size.y
        
    orig_y = position.y

    door_sfx = FmodEventEmitter3D.new()
    door_sfx.event_guid = "{47f9c732-ebc5-46ad-aac3-6e1cb9b686c9}"
    add_child(door_sfx)

    stop_sfx = FmodEventEmitter3D.new()
    stop_sfx.event_guid = "{4ea24e3f-d490-4e21-885c-a5cb2cca6f81}"
    add_child(stop_sfx)

func targetfunc() -> void:
    is_moving_up = true

func _process(_delta: float) -> void:
    if Engine.is_editor_hint():
        return

    if is_moving_up:
        if position.y - orig_y - height < -buffer:
            if not door_sfx_has_played:
                door_sfx.play()
                door_sfx_has_played = true
            stop_sfx_has_played = false
            position.y += speed
        else:
            door_sfx.stop()
            door_sfx_has_played = false
            if not stop_sfx_has_played:
                stop_sfx.play()
                stop_sfx_has_played = true
            position.y = height + orig_y - buffer
            if autoclose:
                await get_tree().create_timer(1).timeout
                is_moving_up = false
    else:
        if position.y > orig_y:
            if not door_sfx_has_played:
                door_sfx.play()
                door_sfx_has_played = true
            stop_sfx_has_played = false
            position.y -= speed
        else:
            door_sfx.stop()
            door_sfx_has_played = false
            if not stop_sfx_has_played:
                stop_sfx.play()
                stop_sfx_has_played = true
            position.y = orig_y