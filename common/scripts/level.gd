extends Node2D
class_name Level

@onready var platforms: Node2D = $Platforms
@onready var gui: GUI = $CanvasLayer/GUI

@export var platform_group_total := 3

var appeared_count := 0

func _ready() -> void: 
	GameState.start_count_down()
	GameState.count_down_over.connect(_on_count_down_over)
	_on_count_down_over()

func _on_count_down_over() -> void:
	var appeared_turn := appeared_count % platform_group_total
	for platform in platforms.get_children():
		if platform is Platform:
			platform.update_existence(appeared_turn, platform_group_total)
			gui.update_count_down_color(appeared_turn, platform_group_total)
	appeared_count += 1
	
