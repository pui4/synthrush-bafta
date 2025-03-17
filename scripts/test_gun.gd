extends Node3D

@onready var shoot_emitter = $"Shoot"
@onready var anim = $"AnimationPlayer"
@onready var gun_end = $"Gun End"
@onready var line_render = $"LineRenderer3D"
@onready var flash = $"Gun End/Flash"
@onready var flash_timer = $"Gun End/Stop Flash"

var can_shoot = true
var anim_speed = 1

func _process(_delta: float) -> void:
    anim.speed_scale = anim_speed

    if Input.is_action_just_pressed("shoot") and can_shoot and not Lib.soft_pause:
        print(Lib.player_raycast.get_collider())
        if anim.is_playing():
            anim_speed *= 1.5
        anim.play("shoot")
        shoot_emitter.play_one_shot()
        shoot()
        can_shoot = false
        flash.show()
        flash_timer.start()
    
    if line_render.start_thickness > 0:
        line_render.start_thickness -= 0.1
        line_render.end_thickness -= 0.1
    
    if can_shoot:
        line_render.points[0] = gun_end.global_position

func shoot():
    if Lib.player_raycast.is_colliding():
        var hit = Lib.player_raycast.get_collider()
        if hit.is_in_group("enemy"):
            hit.health -= 10
        line_render.start_thickness = 1
        line_render.end_thickness = 1
        line_render.points[1] = Lib.player_raycast.get_collision_point()

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
    can_shoot = true
    line_render.start_thickness = 0
    line_render.end_thickness = 0

func _on_stop_flash_timeout() -> void:
    flash.hide()
