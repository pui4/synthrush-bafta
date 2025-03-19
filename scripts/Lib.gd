extends Node

# Item ids:
# 1: test gun
@export var current_player_items : Array[int]
@export var current_equip_item : int = 0

# Cyber ids:
# 1: graple
@export var current_player_cyber : Dictionary = {
	"hand": 0,
	"hip": 0
}

# 0: head
# 1: hand
# 2: hip
# 3: leg
@export var unlocked_slots : Array[bool] = [
	false, false, false, false
]

@export var player : Node3D
@export var player_raycast : RayCast3D
@export var player_health = 100
@export var player_location : Vector3
@export var soft_pause : bool = false
@export var music_player : FmodEventEmitter3D

signal knockback_player(vector : Vector3)
signal start_player_graple(point : Vector3, object : Node3D)
signal stop_player_graple()
signal player_stop_retract()

signal start_pause()
signal stop_pause()

@export var enemy_defintions = [
	preload("res://enemys/test_enemy.tscn"),
	preload("res://enemys/close_enemy.tscn")
]

var ui = preload("res://ui/game_ui.tscn")
var ui_inst : Control
func _ready() -> void:
	ui_inst = ui.instantiate()
	add_child(ui_inst)
	music_player = FmodEventEmitter3D.new()
	add_child(music_player)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart") or player_health <= 0:
		current_player_items = []
		current_equip_item = 0
		current_player_cyber = {
			"hand": 0,
			"hip": 0
		}
		player_health = 100
		get_tree().reload_current_scene()
	
	if currently_in_wave:
		all_enems_dead = true
		for i in wave_enems:
			if i != null:
				all_enems_dead = false
		if all_enems_dead == true:
			wave_done.emit(wave_id)
			currently_in_wave = false

func use_targets(target: String) -> void:
	# Targetnames are really Godot Groups, so we can have multiple entities 
	# share a common "targetname" in Trenchbroom.
	var target_list: Array[Node] = get_tree().get_nodes_in_group(target)
	for targ in target_list:
		if targ.has_method('targetfunc'):
			targ.call('targetfunc')

func set_targetname(node: Node, targetname: String) -> void:
	if node != null and not targetname.is_empty():
		node.add_to_group(targetname)

func load_level(lv_name : String):
	player_health = 100
	var level = load("res://maps/" + lv_name + ".tscn")
	var level_inst = level.instantiate()
	get_tree().root.add_child(level_inst)
	get_tree().unload_current_scene()
	get_tree().current_scene = level_inst

func do_soft_pause() -> void:
	soft_pause = true

func pause() -> void:
	start_pause.emit()
	get_tree().paused = true

func unpause() -> void:
	soft_pause = false
	stop_pause.emit()
	get_tree().paused = false

# Enemy waves
signal wave_done(id : int)

var wave_id : int
var wave_enems : Array[Node3D]
var all_enems_dead : bool
var currently_in_wave : bool = false
func start_wave(id : int, target : String):
	currently_in_wave = true
	wave_id = id
	var target_list: Array[Node] = get_tree().get_nodes_in_group(target)
	for targ in target_list:
		if targ.has_method('targetfunc'):
			wave_enems.append(targ.call('targetfunc'))
	print(wave_enems)