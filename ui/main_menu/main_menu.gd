extends Control

@export var level_preview_scene: PackedScene
@export var bgm: AudioStream

@onready var credit_container: PanelContainer = $CreditContainer
@onready var level_preview_container: GridContainer = %LevelPreviewContainer
@onready var level_previews: PanelContainer = $LevelPreviews
@onready var main_menu_buttons: VBoxContainer = $MainMenuButtons

const QUIT_ACTION_NAME := "quit"

var save_data: SaveData

func _ready() -> void:
	save_data = SaveManager.get_save_data("cleared_level")
	
	AudioManager.play_background_music(bgm)
	UIManager.action_confirmed.connect(_on_action_confirmed)
	_initialize_level_preview()

func _initialize_level_preview() -> void:
	var last_level := false
	for level in SceneManager.LEVELS:
		var level_preview: LevelPreview = level_preview_scene.instantiate()
		level_preview_container.add_child(level_preview)
		
		var is_cleared = save_data.data.get(level)
		if is_cleared:
			level_preview.setup(level).cleared()
			continue
			
		if not last_level:
			last_level = true
			level_preview.setup(level)
			continue
		
		level_preview.setup(level).locked()

func _on_start_game_button_button_up() -> void:
	level_previews.show()
	
func _on_credit_button_button_up() -> void: 
	main_menu_buttons.hide()
	credit_container.show()
	
func _on_return_button_button_up() -> void: 
	main_menu_buttons.show()
	
	level_previews.hide()
	credit_container.hide()
	
func _on_quit_button_button_up() -> void:
	main_menu_buttons.hide()
	
	UIManager.show_confirmation_panel(QUIT_ACTION_NAME)

func _on_action_confirmed(action_name: String, confirmed: bool) -> void:
	if action_name == QUIT_ACTION_NAME: 
		if confirmed: get_tree().quit()
		else: main_menu_buttons.show()
