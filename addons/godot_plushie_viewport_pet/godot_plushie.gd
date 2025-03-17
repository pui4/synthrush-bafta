@tool
class_name GodotPlushieViewportPet
extends AnimatedSprite2D

var main_screen: CanvasItem # Assigned by plugin
@onready var idle_timer := %IdleTimer

var target: float
@export var speed: float = 100.0
@export var snooze_timeout: float = 30.0 # Time in seconds before snoozing

enum State {IDLE, RUN, SNOOZE} # TODO: Implement yoinking the mouse using Input.warp_mouse()
var state: State = State.IDLE

var half_size: float = sprite_frames.get_frame_texture("idle", 0).get_size().x * scale.x / 2.0

var last_input_time: int

func find_new_target() -> void:
	var mouse_position := main_screen.get_local_mouse_position()
	if main_screen.get_rect().has_point(mouse_position):
		target = mouse_position.x
	else:
		target = randf_range(half_size, main_screen.size.x - half_size)
	state = State.RUN

func _ready() -> void:
	if not is_instance_valid(main_screen): # Only run if spawned by plugin
		return
	last_input_time = Time.get_ticks_msec()
	position = Vector2(half_size, main_screen.size.y)
	play("idle")
	idle_timer.timeout.connect(find_new_target)
	find_new_target()

func _process(delta: float) -> void:
	if not is_instance_valid(main_screen): # Only run if spawned by plugin
		return
	position.y = main_screen.size.y
	var idle_time = Time.get_ticks_msec() - last_input_time
	match state:
		State.IDLE:
			play("idle")
			if idle_time > snooze_timeout * 1000:
				state = State.SNOOZE
				idle_timer.stop()
		State.RUN:
			play("run")
			var difference = target - position.x
			if abs(difference) < 1.0:
				idle_timer.wait_time = randf_range(1.0, 10.0)
				idle_timer.start()
				state = State.IDLE
			else:
				position.x += clampf(difference, -1.0, 1.0) * speed * delta
				flip_h = difference < 0.0
		State.SNOOZE:
			play("snooze")
	var max_x: float = main_screen.size.x - half_size
	position.x = clamp(position.x, half_size, max_x)
	target = clamp(target, half_size, max_x)

func _input(event: InputEvent) -> void:
	last_input_time = Time.get_ticks_msec()
	if state == State.SNOOZE:
		state = State.IDLE
		idle_timer.start()