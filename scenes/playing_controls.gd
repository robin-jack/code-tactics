extends Control

signal to_setup

@onready var show_qr = $ShowQR
@onready var popup_qr = $PopupQR
@onready var secret_map = $SubViewport/MarginContainer/SecretMap

func _ready():
	Global.current_menu = Global.MENU.PLAYING
	secret_map.create_secret_grid()
	var url = await secret_map.create_secret_image()
	popup_qr.set_qr(url)
	show_qr.disabled = false

func _on_to_setup_button_up():
	to_setup.emit()

func _on_show_qr_button_up():
	popup_qr.popup.popup_centered()
	popup_qr.margin.custom_minimum_size = Vector2(size.y/2, size.y/2)
