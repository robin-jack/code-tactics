extends Control

@onready var popup = $PopupPanel
@onready var margin = $PopupPanel/MarginContainer
@onready var qr = $PopupPanel/MarginContainer/VBoxContainer/SecretQR

func _ready():
	margin.custom_minimum_size = Vector2(size.y/2, size.y/2)

func set_qr(url):
	qr.set_data(url)
