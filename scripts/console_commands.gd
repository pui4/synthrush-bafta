extends Node

func pl_forward_speed(speed: String) -> void:
    Lib.player.forward_speed = speed.to_float()
func pl_max_speed(speed: String) -> void:
    Lib.player.max_speed = speed.to_float()
func pl_max_acceleration(speed: String) -> void:
    Lib.player.max_accel = speed.to_float()
func pl_side_speed(speed: String) -> void:
    Lib.player.side_speed = speed.to_float()
func pl_friction(friction: String) -> void:
    Lib.player.friction = friction.to_float()
func pl_max_lean_deg(deg: String) -> void:
    Lib.player.max_lean_deg = deg.to_float()
func pl_lean_div(div: String) -> void:
    Lib.player.lean_div = div.to_float()
func pl_air_friction(friction: String) -> void:
    Lib.player.air_friction = friction.to_float()
func pl_wallbouce_vector(x: String, y: String, z: String) -> void:
    Lib.player.wallbouce_vector = Vector3(x.to_float(), y.to_float(), z.to_float())
func pl_direction_wallbounce_mulitplier(multiplier: String) -> void:
    Lib.player.direction_wallbounce_mulitplier = multiplier.to_float()
func pl_air_strafe_multiplier(multipler: String) -> void:
    Lib.player.air_strafe_multiplier = multipler.to_float()
func pl_graple_reel_speed(speed: String) -> void:
    Lib.player.graple_reel_speed = speed.to_float()
func pl_gravity(gravity: String) -> void:
    Lib.player.gravity = gravity.to_float()
func pl_jump_height(height: String) -> void:
    Lib.player.jump_height = height.to_float()
func pl_max_fall_speed(speed: String) -> void:
    Lib.player.max_fall_speed = speed.to_float()
func pl_hand_vel_div(div: String) -> void:
    Lib.player.hand_vel_div = div.to_float()
func pl_max_hand_dist(distance: String) -> void:
    Lib.player.max_hand_dist = distance.to_float()
func pl_hand_lerp_speed(speed: String) -> void:
    Lib.player.hand_lerp_speed = speed.to_float()
func pl_lookspeed(speed: String) -> void:
    Lib.player.lookspeed = speed.to_float()
func pl_health(health: String) -> void:
    Lib.player_health = health.to_int()
func em_spawn(id: String) -> void:
    if Lib.player_raycast.is_colliding():
        var em = Lib.enemy_defintions[id.to_int()].instantiate()
        get_tree().current_scene.add_child(em)
        em.global_position = Lib.player_raycast.get_collision_point()
func wp_give(id: String) -> void:
    Lib.current_player_items.append(id.to_int())
func cb_hand_set(id: String) -> void:
    Lib.current_player_cyber["hand"] = id.to_int()
func cb_hip_set(id: String) -> void:
    Lib.current_player_cyber["hip"] = id.to_int()
func cb_unlock_slot(id: String) -> void:
    Lib.unlocked_slots[id.to_int()] = true

func _ready() -> void:
    Console.pause_enabled = true

    Console.add_command("pl_forward_speed", pl_forward_speed, ["speed"], 1)
    Console.add_command("pl_max_speed", pl_max_speed, ["speed"], 1)
    Console.add_command("pl_max_acceleration", pl_max_acceleration, ["speed"], 1)
    Console.add_command("pl_side_speed", pl_side_speed, ["speed"], 1)
    Console.add_command("pl_friction", pl_friction, ["friction"], 1)
    Console.add_command("pl_max_lean_deg", pl_max_lean_deg, ["deg"], 1)
    Console.add_command("pl_air_friction", pl_air_friction, ["friction"], 1)
    Console.add_command("pl_wallbouce_vector", pl_wallbouce_vector, ["x", "y", "z"], 3)
    Console.add_command("pl_direction_wallbounce_mulitplier", pl_direction_wallbounce_mulitplier, ["multiplier"], 1)
    Console.add_command("pl_air_strafe_multiplier", pl_air_strafe_multiplier, ["multiplier"], 1)
    Console.add_command("pl_graple_reel_speed", pl_graple_reel_speed, ["speed"], 1)
    Console.add_command("pl_gravity", pl_gravity, ["gravity"], 1)
    Console.add_command("pl_jump_height", pl_jump_height, ["height"], 1)
    Console.add_command("pl_max_fall_speed", pl_max_fall_speed, ["speed"], 1)
    Console.add_command("pl_hand_vel_div", pl_hand_vel_div, ["div"], 1)
    Console.add_command("pl_max_hand_dist", pl_max_hand_dist, ["distance"], 1)
    Console.add_command("pl_hand_lerp_speed", pl_hand_lerp_speed, ["speed"], 1)
    Console.add_command("pl_lookspeed", pl_lookspeed, ["speed"], 1)
    Console.add_command("pl_health", pl_health, ["health"], 1)
    Console.add_command("em_spawn", em_spawn, ["id"], 1)
    Console.add_command("wp_give", wp_give, ["id"], 1)
    Console.add_command("cb_hand_set", cb_hand_set, ["id"], 1)
    Console.add_command("cb_hip_set", cb_hip_set, ["id"], 1)
    Console.add_command("load_map", Lib.load_level, ["map"], 1)
    Console.add_command("cb_unlock_slot", cb_unlock_slot, ["id"], 1)