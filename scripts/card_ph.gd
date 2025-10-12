# CARD PLACEHOLDER
extends Control

const CARD_FAKEBOARD = preload("res://assets/sprites/card_fakeboard.png")
const CARD_FAKEBOARD_SMALL = preload("res://assets/sprites/card_fakeboard_small.png")

var texture: Texture2D = CARD_FAKEBOARD
var small: bool = false

@onready var texture_button = $TextureButton
@onready var label = $TextureButton/Label

@export var word: String = "electroencefalogra"
@export var type: int = 0

signal menu(card)

func _ready():
	label.text = word
	_set_texture()
	await get_tree().process_frame
	_center_text()

func _set_texture():
	if small:
		texture = CARD_FAKEBOARD_SMALL
		self.custom_minimum_size = Vector2(145, 97)
	else:
		texture = CARD_FAKEBOARD
		self.custom_minimum_size = Vector2(175, 117)
	texture_button.texture_normal = texture

func _center_text():
	if label.size.x > 335:
		label.add_theme_font_size_override("font_size", 20)
	elif label.size.x > 255:
		label.add_theme_font_size_override("font_size", 25)
	elif label.size.x > 200:
		label.add_theme_font_size_override("font_size", 35)
	await get_tree().process_frame
	label.pivot_offset = label.size / 2.0

func _on_texture_button_button_up():
	menu.emit(self)
