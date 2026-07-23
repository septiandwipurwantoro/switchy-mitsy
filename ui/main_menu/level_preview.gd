extends PanelContainer

@export_file() var level_scene_path: String

func _on_play_button_button_up() -> void:
	SceneManager.change_scene(level_scene_path)
