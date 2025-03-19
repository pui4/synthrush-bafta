extends Node3D

@export var music_guid : String

func _ready() -> void:
    Lib.music_player.event_guid = music_guid
    Lib.music_player.play()