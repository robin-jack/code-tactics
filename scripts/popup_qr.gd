extends Control

@onready var popup = $PopupPanel
@onready var margin = $PopupPanel/MarginContainer
@onready var qr = %QRCodeRect
@onready var label = $PopupPanel/MarginContainer/VBoxContainer/Label

@export var title: String = "qr title"

func _ready():
	label.text = title
