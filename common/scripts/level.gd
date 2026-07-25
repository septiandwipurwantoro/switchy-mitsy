extends Node2D
class_name Level

@export var platform_group_total := 3

@onready var platforms: Node2D = $Platforms
@onready var gui: GUI = $CanvasLayer/GUI
@onready var main_menu_scene := "res://ui/main_menu/main_menu.tscn"

var appeared_count := 0

var is_game_cleared := false

func _ready() -> void: 
	GameState.start_count_down(platform_group_total)
	GameState.count_down_over.connect(_on_count_down_over)
	_on_count_down_over()
	
	for platform in platforms.get_children():
		if platform is SpikedPlatform:
			platform.player_hit.connect(_on_player_hit)

func _on_count_down_over() -> void:
	var appeared_turn := appeared_count % platform_group_total
	for platform in platforms.get_children():
		if platform is Platform:
			platform.update_existence(appeared_turn, platform_group_total)
			gui.update_count_down_color(appeared_turn, platform_group_total)
			
	appeared_count += 1

func _on_player_hit() -> void:
	print("player got hit")

func _on_dead_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if is_game_cleared: return
		get_tree().paused = true
		gui.show_game_over_panel()

func _on_finish_area_body_entered(body: Node2D) -> void:
	if body is Player:
		is_game_cleared = true
		
		var save_data: SaveData = SaveManager.get_save_data("cleared_level")
		var level_name := get_tree().current_scene.scene_file_path
		save_data.set_data(level_name, true)
		SaveManager.save_game()
		
		gui.show_level_cleared_panel()
