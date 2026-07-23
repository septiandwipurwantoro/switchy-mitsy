extends Node

signal count_down_over

const COUNT_DOWN_RANGE := Vector2(5.0, 10.0)

var next_count_down := 0.0
var count_down := 0.0
var count_down_enabled := false

func _ready() -> void:
	count_down = randf_range(COUNT_DOWN_RANGE.x, COUNT_DOWN_RANGE.y)
	next_count_down = randf_range(COUNT_DOWN_RANGE.x, COUNT_DOWN_RANGE.y)

func _process(delta: float) -> void:
	if not count_down_enabled: return
	
	count_down -= delta
	if count_down <= 0:
		count_down = next_count_down
		next_count_down = randf_range(COUNT_DOWN_RANGE.x, COUNT_DOWN_RANGE.y)
		count_down_over.emit()

func start_count_down() -> void: count_down_enabled = true
func end_count_down() -> void: count_down_enabled = false
