extends Node

signal count_down_over

const COUNT_DOWN_RANGE := Vector2(5.0, 10.0)

var next_count_down := 0.0
var count_down := 0.0
var count_down_enabled := false

var count_down_total := 0
var count_cycle_size := 0

func _process(delta: float) -> void:
	if not count_down_enabled: return
	
	count_down -= delta
	if count_down <= 0:
		count_down = next_count_down
		next_count_down = Platform.COLOR_TIMER[count_down_total % count_cycle_size]
		count_down_total += 1
		count_down_over.emit()

func start_count_down(cycle_size: int) -> void: 
	count_down = Platform.COLOR_TIMER[0]
	next_count_down = Platform.COLOR_TIMER[1]
	count_down_total = 2
	
	count_cycle_size = cycle_size
	count_down_enabled = true
	
func end_count_down() -> void: count_down_enabled = false
