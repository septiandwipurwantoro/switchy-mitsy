extends PanelContainer
class_name LevelPreview

@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect
@onready var play_button: Button = $VBoxContainer/PlayButton

var level_scene_path: String

func setup(level: String) -> LevelPreview:
	texture_rect.texture = SceneManager.get_level_preview_img(level)
	level_scene_path = level
	return self
	
func cleared() -> LevelPreview:
	play_button.text = "Play Again"
	return self

func locked() -> LevelPreview:
	texture_rect.modulate = Color(0.6, 0.6, 0.6, 1.0)
	play_button.disabled = true
	play_button.text = "Locked"
	return self

func _on_play_button_button_up() -> void:
	AudioManager.play_sfx("button_click")
	SceneManager.change_scene(level_scene_path)
