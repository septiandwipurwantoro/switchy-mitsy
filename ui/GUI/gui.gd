extends Control

@onready var pause_container: PanelContainer = $PauseContainer
@onready var main_menu_scene := "res://ui/main_menu/main_menu.tscn"

func _on_pause_button_button_up() -> void: pause_container.show()
func _on_return_button_button_up() -> void: pause_container.hide()
func _on_main_menu_button_button_up() -> void: SceneManager.change_scene(main_menu_scene)
