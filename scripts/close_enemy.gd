extends CharacterBody3D

@export var health : int = 100

@onready var nav : NavigationAgent3D = $"NavigationAgent3D"
@onready var pounce_cooldown : Timer = $"Pounce Cooldown"

@onready var pounce_sfx : FmodEventEmitter3D = $"Pounce"
@onready var footsteps_sfx : FmodEventEmitter3D = $"Footsteps"
@onready var hurt_sfx : FmodEventEmitter3D = $"Hurt"
@onready var death_sfx : FmodEventEmitter3D = $"Death"
@onready var collider : CollisionShape3D = $"CollisionShape3D"
@onready var hitbox_collider : CollisionShape3D = $"Hit Box/CollisionShape3D"
@onready var blood_splater : GPUParticles3D = $"GPUParticles3D"
@onready var body : Node3D = $"daniel filth grub"
@onready var anim : AnimationPlayer = $"daniel filth grub/AnimationPlayer"

@export var speed : float
@export var pounce_distance : float
@export var pounce_vel : float
@export var gravity : float
@export var max_fall_speed : float
@export var damage : int
@export var knockback : Vector3

var can_pounce = false
var done_pouncing = false
var player_dir : Vector3
var old_heath : int
var dead = false

func _ready() -> void:
	look_at(Lib.player_location)
	rotation_degrees.y += 180
	rotation.x = 0
	nav.set_target_position(Lib.player_location)
	footsteps_sfx.play()
	old_heath = health

func _process(_delta: float) -> void:
	if health <= 0 and not dead:
		death_sfx.play()
		footsteps_sfx.stop()
		hurt_sfx.stop()
		pounce_sfx.stop()

		hitbox_collider.disabled = true
		collider.disabled = true

		blood_splater.emitting = true

		body.hide()
		dead = true
	
	if health != old_heath:
		hurt_sfx.play()
		old_heath = health

func navigate() -> void:
	if footsteps_sfx.paused:
		footsteps_sfx.paused = false

	nav.set_target_position(Lib.player_location)
	if NavigationServer3D.map_get_iteration_id(nav.get_navigation_map()) == 0:
		return
	if nav.is_navigation_finished():
		return

	var next_path_position: Vector3 = nav.get_next_path_position()
	look_at(next_path_position)
	rotation_degrees.y += 180
	rotation.x = 0
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * speed

	if nav.avoidance_enabled:
		nav.set_velocity(new_velocity)
	else:
		_on_navigation_agent_3d_velocity_computed(new_velocity)

func pounce() -> void:
	anim.play("leap")
	footsteps_sfx.paused = true

	if player_dir == Vector3.ZERO:
		pounce_sfx.play_one_shot()
		player_dir = global_position.direction_to(Lib.player_location)

	velocity = player_dir * pounce_vel

func _physics_process(_delta: float) -> void:
	if not can_pounce and not dead:
		done_pouncing = false
		navigate()

	if global_position.distance_to(Lib.player_location) <= pounce_distance and not done_pouncing:
		pounce()
		can_pounce = true

	if not is_on_floor():
		velocity.y -= gravity
		velocity.y = clamp(velocity.y, -max_fall_speed, max_fall_speed)
	
	if not dead and not Lib.soft_pause:
		move_and_slide()

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity

func _on_pounce_cooldown_timeout() -> void:
	done_pouncing = true

func _on_death_stopped() -> void:
	queue_free()

func _on_hit_box_body_entered(body : Node3D) -> void:
	if body.is_in_group("player"):
		Lib.knockback_player.emit(knockback)
		Lib.player_health -= damage

func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	if anim_name == "leap":
		player_dir = Vector3.ZERO
		pounce_cooldown.start()
		can_pounce = false
		anim.play("run")
