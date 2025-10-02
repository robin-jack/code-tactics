extends Control

@export var fakeboard: Node

const CARD_PH = preload("res://assets/sprites/card_placeholder.png")
const CARD_PH_SMALL = preload("res://assets/sprites/card_placeholder_small.png")
const CARD_PLACEHOLDER = preload("res://scenes/prefabs/CardPlaceholder.tscn")

var card_texture: Texture = CARD_PH

func _ready():
	for i in Global.num_cards:
		#var card_ph = CARD_PLACEHOLDER.instantiate()
		var card_ph = create_placeholder()
		fakeboard.add_child(card_ph)

func show_advanced_settings():
	fakeboard.scale = Vector2(0.5, 0.5)

func create_placeholder():
	var card = TextureRect.new()
	card.texture = card_texture
	if card_texture == CARD_PH_SMALL:
		card.size = Vector2(140, 94)
	else:
		card.size = Vector2(200, 133)
	return card

func _on_button_20_button_up():
	_update_fakeboard(5, 20, CARD_PH)

func _on_button_25_button_up():
	_update_fakeboard(5, 25, CARD_PH)

func _on_button_30_button_up():
	_update_fakeboard(6, 30, CARD_PH_SMALL)

func _on_button_36_button_up():
	_update_fakeboard(6, 36, CARD_PH_SMALL)

func _on_advanced_button_button_up():
	show_advanced_settings()

func _update_fakeboard(col, num_cards, tex):
	for child in fakeboard.get_children():
		child.queue_free()
	
	card_texture = tex
	for i in range(num_cards):
		var card_ph = create_placeholder()
		fakeboard.add_child(card_ph)
			
	fakeboard.set_columns(col)
