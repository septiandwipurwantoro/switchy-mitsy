extends Control
class_name GUI

@onready var pause_container: PanelContainer = $PauseContainer
@onready var count_down_label: Label = $TimerPanel/VBoxContainer/CountDownLabel
@onready var next_count_down_label: Label = $TimerPanel/VBoxContainer/NextCountDownLabel
@onready var level_cleared_panel: PanelContainer = $LevelClearedPanel
@onready var game_over_panel: PanelContainer = $GameOverPanel
@onready var main_menu_scene := "res://ui/main_menu/main_menu.tscn"

func _ready() -> void:
	GameState.count_down_over.connect(_on_count_down_over)
	_on_count_down_over()

func _process(delta: float) -> void:
	if GameState.count_down_enabled:
		count_down_label.text = str(int(GameState.count_down))

func show_level_cleared_panel() -> void: level_cleared_panel.show()
func show_game_over_panel() -> void: game_over_panel.show()

func update_count_down_color(appeared_turn: int, platform_group_total: int) -> void:
	count_down_label.add_theme_color_override("font_color", Platform.COLOR_CODE[appeared_turn])
	next_count_down_label.add_theme_color_override(
		"font_color", Platform.COLOR_CODE[(appeared_turn + 1) % platform_group_total])
		
func _on_count_down_over() -> void: next_count_down_label.text = str(int(GameState.next_count_down))

func _on_pause_button_button_up() -> void: 
	get_tree().paused = true
	pause_container.show()
	
func _on_return_button_button_up() -> void:
	get_tree().paused = false
	pause_container.hide()
	
func _on_main_menu_button_button_up() -> void:
	get_tree().paused = false
	SceneManager.change_scene(main_menu_scene)

func _on_next_level_button_button_up() -> void:
	var current_level := get_tree().current_scene.scene_file_path
	SceneManager.change_to_next_level(current_level)

func _on_try_again_button_button_up() -> void: 
	get_tree().paused = false
	SceneManager.reload_current_scene()
	
