extends CharacterBody2D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED := 300.0
const JUMP_VELOCITY := -400.0
const MAX_JUMPS := 2

const WALL_SLIDE_SPEED := 100.0
const WALL_SLIDE_DURATION := 1.5

const WALL_JUMP_PUSH := 350.0
const WALL_JUMP_UP := -400.0
const WALL_JUMP_UP_ONLY := -450.0
const FAST_FALL_SPEED := 600.0

var is_wall_sliding := false
var wall_slide_timer := 0.0
var jumps_used := 0

func _physics_process(delta: float) -> void:
	_update_wall_slide_state(delta)
	_apply_gravity(delta)
	_handle_jump()
	_handle_movement()
	_handle_wall_jump()
	move_and_slide()

func _update_wall_slide_state(delta: float) -> void:
	if is_on_wall() and not is_on_floor() and velocity.y >= 0.0:
		if not is_wall_sliding:
			is_wall_sliding = true
			wall_slide_timer = WALL_SLIDE_DURATION
			jumps_used = 0
			
		wall_slide_timer -= delta
	else: 
		is_wall_sliding = false

func _apply_gravity(delta: float) -> void:
	if is_on_floor():
		return

	if is_wall_sliding and wall_slide_timer > 0:
		velocity.y += get_gravity().y * delta
		velocity.y = min(velocity.y, WALL_SLIDE_SPEED)
	else:
		velocity += get_gravity() * delta

func _handle_jump() -> void:
	if is_on_floor():
		jumps_used = 0

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jumps_used = 1
		elif not is_on_wall() and jumps_used < MAX_JUMPS:
			velocity.y = JUMP_VELOCITY
			jumps_used += 1

func _handle_wall_jump() -> void:
	if not is_on_wall():
		return
	
	if jumps_used < MAX_JUMPS:
		if Input.is_action_just_pressed("move_left"):
			velocity.x = -WALL_JUMP_PUSH
			velocity.y = WALL_JUMP_UP
			_reset_after_wall_jump()
		elif Input.is_action_just_pressed("move_right"):
			velocity.x = WALL_JUMP_PUSH
			velocity.y = WALL_JUMP_UP
			_reset_after_wall_jump()
		elif Input.is_action_just_pressed("move_down"):
			velocity.y = FAST_FALL_SPEED
			jumps_used = MAX_JUMPS
			wall_slide_timer = 0

func _reset_after_wall_jump() -> void:
	jumps_used += 1
	is_wall_sliding = false

func _handle_movement() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * SPEED

	if velocity.x == 0.0:
		animated_sprite_2d.play("idle")
		return

	animated_sprite_2d.play("run")
	animated_sprite_2d.flip_h = direction < 0
