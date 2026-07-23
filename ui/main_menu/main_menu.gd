extends Control

@onready var credit_container: PanelContainer = $CreditContainer
@onready var level_previews: PanelContainer = $LevelPreviews
@onready var main_menu_buttons: VBoxContainer = $MainMenuButtons

const QUIT_ACTION_NAME := "quit"

func _ready() -> void:
	SaveManager.load_game()
	UIManager.action_confirmed.connect(_on_action_confirmed)

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
