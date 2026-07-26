extends Camera2D

@export var target: Player

const SHAKE_STRENGTH: float = 8.0
const SHAKE_DURATION: float = 0.3
const SHAKE_COUNT: int = 6

var base_camera_offset :=  Vector2.ZERO
var _shake_tween: Tween

func _ready() -> void:
	GameState.count_down_over.connect(_shake_camera)
	
	base_camera_offset = Vector2(0, -240)
	offset = base_camera_offset
	
	position_smoothing_enabled = false
	global_position = target.global_position
	
	await get_tree().process_frame
	position_smoothing_enabled = true

func _process(delta: float) -> void:
	if not target: return
	
	global_position.x = target.global_position.x
	if not target.is_jumping and not target.is_wall_sliding:
		var viewport_size_y = get_viewport().get_visible_rect().size.y
		global_position.y = lerp(global_position.y, viewport_size_y, 0.1)
	else: global_position.y = lerp(global_position.y, target.global_position.y, 0.1)
	
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
		_shake_tween.tween_property(self, "offset", base_camera_offset + offset, step_time)

	_shake_tween.tween_property(self, "offset", base_camera_offset, step_time)
