extends Control

const next: String = "res://scenes/BoardSettings.tscn"
signal transitioned(scn)

func _on_next_button_button_up():
	transitioned.emit(next)
