extends Node2D
class_name Level

@onready var platforms: Node2D = $Platforms

@export var platform_group_total := 3

var appeared_count := 0

func _ready() -> void: 
	GameState.start_count_down()
	GameState.count_down_over.connect(_on_count_down_over)
	_update_platform_existence()

func _on_count_down_over() -> void:
	_update_platform_existence()
	appeared_count += 1

func _update_platform_existence() -> void:
	var appeared_turn := appeared_count % platform_group_total
	for platform in platforms.get_children():
		if platform is Platform:
			platform.update_existence(appeared_turn, platform_group_total)
	
