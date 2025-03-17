extends CharacterBody3D

@export var forward_speed : float
@export var side_speed : float
@export var max_speed : float
@export var max_accel : float
@export var friction : float
@export var max_lean_deg : float
@export var lean_div : float
@export var air_friction : float
@export var wallbouce_vector : Vector3
@export var direction_wallbounce_mulitplier : float
@export var air_strafe_multiplier : float
@export var graple_reel_speed : float

@export var gravity : float
@export var jump_height : float
@export var max_fall_speed : float

@export var hand_vel_div : float
@export var max_hand_dist : float
@export var hand_lerp_speed : float

@export var lookspeed : float

@onready var head = $"Head"
@onready var camera = $"Head/Camera3D"
@onready var hand_ui = $"Head/CanvasLayer"
@onready var hand_cam = $"Head/CanvasLayer/SubViewportContainer/SubViewport/Camera3D2"
@onready var hand = $"Head/hand"
@onready var orig_hand_pos = hand.position
@onready var raycast = $"Head/RayCast3D"

@onready var footsteps_emitter = $"Footsteps"
@onready var jump_emitter = $"Jump"
@onready var double_jump_emitter = $"Double Jump"
@onready var hurt_emitter = $"Hurt"

@onready var wallbounce_left = $"Wallbounce/left"
@onready var wallbounce_right = $"Wallbounce/right"

var lowered_side_speed : float
var orig_side_speed : float
var is_double = false
var was_in_air = false
var is_playing = false
var old_heath : int
var graple_point : Vector3
var graple_object : Node3D
var console_open : bool = false

func _ready() -> void:
  Lib.knockback_player.connect(_on_knockback)
  Lib.start_player_graple.connect(_on_graple_start)
  Lib.stop_player_graple.connect(_on_graple_stop)
  Lib.start_pause.connect(_start_pause)
  Lib.stop_pause.connect(_stop_pause)
  Lib.player_location = global_position
  Lib.player_raycast = raycast
  Lib.player = self
  old_heath = Lib.player_health

  max_accel *= max_speed
  lowered_side_speed = side_speed * air_strafe_multiplier
  orig_side_speed = side_speed

  Console.console_closed.connect(_on_console_close)
  Console.console_opened.connect(_on_console_open)

  Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
  if event is InputEventMouseMotion and not console_open and not Lib.soft_pause:
    rotate_y(deg_to_rad(-event.relative.x * lookspeed))
    head.rotate_x(deg_to_rad(-event.relative.y * lookspeed))
    head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
  elif event is InputEventKey and not console_open:
    if event.keycode == KEY_ESCAPE:
      Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(_delta: float) -> void:
  hand_cam.global_position = camera.global_position
  hand_cam.global_rotation = camera.global_rotation

  if old_heath != Lib.player_health:
    hurt_emitter.play()
    old_heath = Lib.player_health

func _physics_process(delta: float) -> void:
  Lib.player_location = global_position

  # Movement
  var wishdir = Vector3(Input.get_axis("left", "right") * side_speed, 0, Input.get_axis("forward", "backward") * forward_speed).normalized()
  wishdir = wishdir.rotated(Vector3.UP, head.global_rotation.y)
  if wishdir != Vector3.ZERO and not is_playing and is_on_floor() and velocity != Vector3.ZERO:
    footsteps_emitter.play()
    is_playing = true
  elif wishdir == Vector3.ZERO and is_playing or not is_on_floor() or velocity == Vector3.ZERO:
    is_playing = false
    footsteps_emitter.stop()

  var current_speed = velocity.dot(wishdir)
  var add_speed = clamp(max_speed - current_speed, 0, max_accel * delta)
  velocity = velocity + add_speed * wishdir

  var target_lean_rot = velocity.rotated(Vector3.UP, -camera.global_rotation.y).x / lean_div
  target_lean_rot = clamp(target_lean_rot, -max_lean_deg, max_lean_deg)
  camera.rotation.z = deg_to_rad(target_lean_rot)

  # Jumping / Gravity
  if not is_on_floor():
    velocity.x /= air_friction
    velocity.z /= air_friction
    velocity.y -= gravity
    velocity.y = clamp(velocity.y, -max_fall_speed, max_fall_speed)
    hand.position.y -= velocity.y / hand_vel_div
    was_in_air = true

    side_speed = lowered_side_speed
  else:
    side_speed = orig_side_speed

    if was_in_air:
      jump_emitter.play_one_shot()
      was_in_air = false
    velocity /= friction
    hand.position.y = lerp(hand.position.y, orig_hand_pos.y, hand_lerp_speed * delta)
  
  hand.position.y = clamp(hand.position.y, -max_hand_dist + orig_hand_pos.y, max_hand_dist + orig_hand_pos.y)

  if (is_on_floor() or is_double) and Input.is_action_just_pressed("jump") and not ((wallbounce_left.is_colliding() or wallbounce_right.is_colliding()) and not is_on_floor()) and graple_point == Vector3.ZERO:
    if not is_on_floor():
      double_jump_emitter.play_one_shot()
      is_double = false
    else:
      jump_emitter.play_one_shot()
      is_double = true
    velocity.y = jump_height
  elif (wallbounce_left.is_colliding() or wallbounce_right.is_colliding()) and Input.is_action_just_pressed("jump") and not is_on_floor():
    if graple_point != Vector3.ZERO:
      is_double = true
      graple_point = Vector3.ZERO

    if wallbounce_left.is_colliding():
      velocity = wallbounce_left.get_collision_normal() * direction_wallbounce_mulitplier + wallbouce_vector.rotated(Vector3.UP, head.global_rotation.y) + wishdir
    elif wallbounce_right.is_colliding():
      velocity = wallbounce_right.get_collision_normal() * direction_wallbounce_mulitplier + wallbouce_vector.rotated(Vector3.UP, head.global_rotation.y) + wishdir
    
    double_jump_emitter.play()

  if (round(graple_point.direction_to(global_position)) == Vector3.DOWN):
    print(graple_point.distance_to(global_position))
  
  if graple_point != Vector3.ZERO and (graple_point.distance_to(global_position) <= 1) or (round(graple_point.direction_to(global_position)) == Vector3.DOWN and graple_point.distance_to(global_position) <= 3.5):
    Lib.player_stop_retract.emit()
    position = graple_point

  if graple_point != Vector3.ZERO:
    camera.rotation.z = 0
    velocity = global_position.direction_to(graple_point) * graple_reel_speed

  if not Lib.soft_pause:
    move_and_slide()

func _on_console_open() -> void:
  Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
  console_open = true
func _on_console_close() -> void:
  Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
  console_open = false

func _on_knockback(vector : Vector3) -> void:
  velocity = vector.rotated(Vector3.UP, head.global_rotation.y)

func _on_graple_start(point : Vector3, object : Node3D) -> void:
  graple_object = object
  graple_point = point

func _on_graple_stop() -> void:
  graple_point = Vector3.ZERO

func _start_pause() -> void:
  hand_ui.hide()

func _stop_pause() -> void:
  hand_ui.show()