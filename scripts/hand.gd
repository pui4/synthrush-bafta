extends Node3D

@export var weapon_definitions : Array[PackedScene]

var old_items = []
func _process(_delta: float) -> void:
	if Lib.current_player_items != old_items:
		for item in Lib.current_player_items:
			if item not in old_items:
				var weap_inst = weapon_definitions[item - 1].instantiate()
				add_child(weap_inst)
				Lib.current_equip_item = item

		old_items = Lib.current_player_items
