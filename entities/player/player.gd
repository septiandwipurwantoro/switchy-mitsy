extends CharacterBody2D
class_name Player

@onready var player_sprites: Node2D = $PlayerSprites
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera_2d: Camera2D = $Camera2D
@onready var particles_dust := $Particles

const SPEED := 300.0
const FRICTION := 10.0
const JUMP_VELOCITY := -400.0
const MAX_JUMPS := 2

const WALL_SLIDE_SPEED := 100.0
const WALL_SLIDE_DURATION := 1.5

const WALL_JUMP_PUSH := 350.0
const WALL_JUMP_UP := -400.0
const WALL_JUMP_UP_ONLY := -450.0
const FAST_FALL_SPEED := 600.0

const SHAKE_STRENGTH: float = 8.0
const SHAKE_DURATION: float = 0.3
const SHAKE_COUNT: int = 6

var is_jumping := false
var is_wall_sliding := false
var wall_slide_timer := 0.0
var jumps_used := 0

var input_disabled := false

var base_camera_offset :=  Vector2.ZERO
var _shake_tween: Tween

func _ready() -> void:
	base_camera_offset = camera_2d.offset
	
	GameState.count_down_over.connect(_shake_camera)

func _physics_process(delta: float) -> void:
	_update_wall_slide_state(delta)
	_apply_gravity(delta)
	_handle_jump()
	_handle_movement(delta)
	_handle_wall_jump()
	move_and_slide()

func get_hit() -> void:
	input_disabled = true
	animation_player.play("jump")
	velocity.y = JUMP_VELOCITY

func _update_wall_slide_state(delta: float) -> void:
	if is_on_wall() and not is_on_floor() and velocity.y >= 0.0:
		if not is_wall_sliding:
			animation_player.play("wall")
			is_jumping = false
			is_wall_sliding = true
			wall_slide_timer = WALL_SLIDE_DURATION
			jumps_used = 0
			
			_update_player_direction()
			
		wall_slide_timer -= delta
	else: 
		is_wall_sliding = false

func _update_player_direction() -> void:
	if is_wall_sliding:
		var collision := get_last_slide_collision()
		if collision:
			var normal := collision.get_normal()

			if normal.x == 0: return
			_flip(normal.x > 0)

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
		is_jumping = false
		jumps_used = 0
	
	if input_disabled: return
	if Input.is_action_just_pressed("jump"):
		if not is_wall_sliding:
			animation_player.play("jump")
			is_jumping = true
			
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
		if input_disabled: return
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
	animation_player.play("jump")
	is_jumping = true
	is_wall_sliding = false

func _handle_movement(delta) -> void:
	if input_disabled: return
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = lerp(velocity.x, direction * SPEED, FRICTION * delta)
	if not is_jumping and not is_wall_sliding:
		if !direction:
			particles_dust.emitting = false
			animation_player.play("idle")
			return
		particles_dust.emitting = true
		animation_player.play("run")
	
	if direction == 0: return
	_flip(direction < 0)
	
func _flip(flipped: bool) -> void:
	if flipped: player_sprites.scale.x = -0.288
	else: player_sprites.scale.x = 0.288

func _shake_camera() -> void:
	if _shake_tween and _shake_tween.is_valid():
		_shake_tween.kill()

	_shake_tween = create_tween()
	var step_time := SHAKE_DURATION / SHAKE_COUNT

	for i in SHAKE_COUNT:
		var offset := Vector2(
			randf_range(-SHAKE_STRENGTH, SHAKE_STRENGTH),
			randf_range(-SHAKE_STRENGTH, SHAKE_STRENGTH)
		)
		_shake_tween.tween_property(camera_2d, "offset", base_camera_offset + offset, step_time)

	_shake_tween.tween_property(camera_2d, "offset", base_camera_offset, step_time)
