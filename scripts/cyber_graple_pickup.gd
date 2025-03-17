extends Node3D

@export var cyber_id : int

@onready var pickup_emitter = $"Pick Up"

var is_picked_up = false

func _on_area_3d_body_entered(body:Node3D) -> void:
	if body.is_in_group("player") and not is_picked_up:
		pickup_emitter.play()
		is_picked_up = true
		hide()
		Lib.current_player_cyber["hip"] = cyber_id

func _on_pick_up_stopped() -> void:
	queue_free()
