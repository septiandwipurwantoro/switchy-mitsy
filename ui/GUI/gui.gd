extends Control

@onready var pause_container: PanelContainer = $PauseContainer
@onready var count_down_label: Label = $TimerPanel/VBoxContainer/CountDownLabel
@onready var main_menu_scene := "res://ui/main_menu/main_menu.tscn"

func _ready() -> void:
	GameState.count_down_over.connect(_on_count_down_over)

func _process(delta: float) -> void:
	if GameState.count_down_enabled:
		count_down_label.text = str(int(GameState.count_down))

func _on_pause_button_button_up() -> void: pause_container.show()
func _on_return_button_button_up() -> void: pause_container.hide()
func _on_main_menu_button_button_up() -> void: SceneManager.change_scene(main_menu_scene)

func _on_count_down_over() -> void:
	pass
