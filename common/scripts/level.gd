extends Node2D
class_name Level

@export var platform_group_total := 3

@onready var platforms: Node2D = $Platforms
@onready var gui: GUI = $CanvasLayer/GUI
@onready var game_over_panel: PanelContainer = %GameOverPanel
@onready var main_menu_scene := "res://ui/main_menu/main_menu.tscn"

const QUIT_ACTION_NAME := "quit"

var appeared_count := 0

func _ready() -> void: 
	UIManager.action_confirmed.connect(_on_action_confirmed)
	
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

func _on_action_confirmed(action_name: String, confirmed: bool) -> void:
	if action_name == QUIT_ACTION_NAME:
		if confirmed: SceneManager.change_scene(main_menu_scene)
		else: game_over_panel.show()
		
func _on_try_again_button_button_up() -> void:
	game_over_panel.hide()
	SceneManager.reload_current_scene()

func _on_main_menu_button_button_up() -> void:
	game_over_panel.hide()
	UIManager.show_confirmation_panel(QUIT_ACTION_NAME)

func _on_dead_area_body_entered(body: Node2D) -> void:
	if body is Player:
		game_over_panel.show()
