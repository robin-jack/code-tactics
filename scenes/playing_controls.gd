extends Control

const back: String = "res://scenes/BoardSettings.tscn"
signal transitioned(scn)

@onready var show_qr = $ShowQR
@onready var popup_qr = $PopupQR
@onready var secret_map = $SubViewport/MarginContainer/SecretMap

func _ready():
	secret_map.create_secret_grid()
	var url = await secret_map.create_secret_image()
	popup_qr.qr.set_data(url)
	show_qr.disabled = false

func _on_show_qr_button_up():
	popup_qr.popup.popup_centered()
	popup_qr.margin.custom_minimum_size = Vector2(size.y/1.5, (size.y/1.5)+100)

func _on_back_button_button_up():
	transitioned.emit(back)
