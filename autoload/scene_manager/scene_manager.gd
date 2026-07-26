extends Node2D
signal transition_finished


@onready var overlay: ColorRect = $CanvasLayer/Overlay

const  LEVELS: Array[String] = [
	"res://levels/level_1.tscn",
	"res://levels/level_2.tscn",
	"res://levels/level_3.tscn"
]
const  MAIN_MENU := "res://ui/main_menu/main_menu.tscn"

const FADE_DURATION := 0.3

func change_scene(scene: String):
	await _fade_in()
	get_tree().change_scene_to_file(scene)
	await _fade_out()
	transition_finished.emit()

func reload_current_scene():
	await _fade_in()
	get_tree().reload_current_scene()
	await _fade_out()
	transition_finished.emit()

func change_to_next_level(current_level: String) -> void:
	var current_index := LEVELS.find(current_level)
	if current_index == -1:
		push_error("Level is not found")
		return

	var next_index := current_index + 1
	if next_index >= LEVELS.size():
		change_scene(MAIN_MENU)
		return

	var next_level := LEVELS[next_index]
	change_scene(next_level)

func _fade_in() -> void:
	overlay.show()
	var tween := create_tween()
	tween.tween_property(overlay, "color:a", 1.0, FADE_DURATION)
	await tween.finished

func _fade_out() -> void:
	var tween := create_tween()
	tween.tween_property(overlay, "color:a", 0.0, FADE_DURATION)
	await tween.finished
	overlay.hide()
