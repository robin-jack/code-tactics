extends Control

@onready var fakeboard = $HBoxContainer/FakeBoard
@onready var vbox = $HBoxContainer/VBoxContainer

const CARD_PLACEHOLDER = preload("res://scenes/prefabs/CardPlaceholder.tscn")

var add_column: bool = false

func _ready():
	fakeboard.resized.connect(_resize_buttons)
	for i in Global.num_cards:
		var card_ph = CARD_PLACEHOLDER.instantiate()
		fakeboard.add_child(card_ph)

func _resize_buttons():
	await get_tree().process_frame
	vbox.custom_minimum_size.y = fakeboard.size.y

func _on_add_button_up():
	if add_column:
		fakeboard.set_columns(fakeboard.columns+1)
	add_column = !add_column
	var to_add = fakeboard.columns
	for n in to_add:
		var card_ph = CARD_PLACEHOLDER.instantiate()
		fakeboard.add_child(card_ph)

func _on_substract_button_up():
	var to_remove = fakeboard.columns
	var cards = fakeboard.get_children()
	for i in range(min(to_remove, cards.size())):
		cards[i].queue_free()
	if !add_column:
		fakeboard.set_columns(fakeboard.columns-1)
	add_column = !add_column
