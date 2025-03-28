extends Control

@onready var panel = $"Panel"
@onready var health_bar = $"Panel/Health Bar"
@onready var health_txt = $"Panel/Health Bar/Health"

@onready var icons = $"Panel/Icons"

var old_equip : int = 0
var old_y : float

func _ready() -> void:
    old_y = panel.position.y

func _process(_delta: float) -> void:
    if Lib.player != null:
        panel.position.y = (-Lib.player.get_node("Head/hand").position.y - 0.368) * 175 + old_y
    
    health_txt.text = "\n" + str(Lib.player_health)
    health_bar.value = Lib.player_health

    if Lib.current_equip_item != old_equip:
        var children = icons.get_children()
        var index = 0
        for child in children:
            if index == old_equip:
                child.hide()
            elif index == Lib.current_equip_item:
                child.show()
            index += 1
        
        old_equip = Lib.current_equip_item