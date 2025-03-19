extends Control

@export var music_guid : String

@onready var fmod_logo = $"TextureRect2"
@onready var loading = $"TextureRect3"

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	loading.show()
	await await get_tree().create_timer(0.1).timeout
	var lev = load("res://maps/arena.tscn")
	var leve = lev.instantiate()
	get_tree().root.add_child(leve)
	get_tree().root.get_node("main_menu").queue_free()
	get_tree().current_scene = leve


func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	fmod_logo.hide()
