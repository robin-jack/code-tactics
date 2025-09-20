extends Button

signal to_setup

func _on_button_up():
	to_setup.emit()
