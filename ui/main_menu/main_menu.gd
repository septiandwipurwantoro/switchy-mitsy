extends Control

@onready var credit_container: PanelContainer = $CreditContainer
@onready var main_menu_buttons: VBoxContainer = $MainMenuButtons

var starting_scene := "res://levels/test_level.tscn"

func _ready() -> void:
	SaveManager.load_game()
	UIManager.action_confirmed.connect(_on_action_confirmed)

func _on_start_game_button_button_up() -> void:
	SceneManager.change_scene(starting_scene)
	
func _on_credit_button_button_up() -> void: 
	main_menu_buttons.hide()
	credit_container.show()
	
func _on_return_button_button_up() -> void: 
	main_menu_buttons.show()
	credit_container.hide()
	
func _on_quit_button_button_up() -> void:
	main_menu_buttons.hide()
	
	var action_name := "quit"
	UIManager.show_confirmation_panel(action_name)

func _on_action_confirmed(action_name: String, confirmed: bool) -> void:
	if action_name == "quit": 
		if confirmed: get_tree().quit()
		else: main_menu_buttons.show()
