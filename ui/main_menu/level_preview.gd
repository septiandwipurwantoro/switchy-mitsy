extends PanelContainer
class_name LevelPreview

@onready var play_button: Button = $VBoxContainer/PlayButton

var level_scene_path: String

func setup(level: String) -> LevelPreview:
	level_scene_path = level
	return self
	
func cleared() -> LevelPreview:
	play_button.text = "Play Again"
	return self

func locked() -> LevelPreview:
	play_button.disabled = true
	play_button.text = "Locked"
	return self

func _on_play_button_button_up() -> void:
	SceneManager.change_scene(level_scene_path)
