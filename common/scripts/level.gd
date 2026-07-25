extends Node2D
class_name Level

@export var platform_group_total := 3

@onready var platforms: Node2D = $Platforms
@onready var gui: GUI = $CanvasLayer/GUI
@onready var main_menu_scene := "res://ui/main_menu/main_menu.tscn"

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

func _on_dead_area_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().paused = true
		GameState.game_over.emit()
