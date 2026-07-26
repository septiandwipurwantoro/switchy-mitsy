extends CanvasLayer

signal action_confirmed(action_name: String, confirmation: bool)

@onready var confirmation_panel: PanelContainer = %ConfirmationPanel
@onready var confimation_label: Label = %ConfimationLabel

var action_name: String

func show_confirmation_panel(action: String, message: String = "Are you sure?") -> void:
	action_name = action
	confimation_label.text = message
	confirmation_panel.show()
	
func _on_cancel_button_button_up() -> void: 
	AudioManager.play_sfx("button_click")
	confirmation_panel.hide()
	action_confirmed.emit(action_name, false)
	
func _on_confirm_button_button_up() -> void: 
	AudioManager.play_sfx("button_click")
	confirmation_panel.hide()
	action_confirmed.emit(action_name, true)
