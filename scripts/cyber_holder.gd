extends Node3D

@export var cyber_definitions : Array[PackedScene]

var old_id : int
func _process(delta: float) -> void:
    if old_id != Lib.current_player_cyber['hand']:
        for child in get_children():
            child.queue_free()

        var cyber_inst = cyber_definitions[Lib.current_player_cyber["hand"]].instantiate()
        add_child(cyber_inst)
        old_id = Lib.current_player_cyber["hand"]