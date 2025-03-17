extends Control

@onready var health_txt = $"Panel/Health"

func _process(_delta: float) -> void:
    if Lib.player != null:
        position.y = (-Lib.player.get_node("Head/hand").position.y - 0.368) * 175
    
    health_txt.text = "[center]" + str(Lib.player_health)
