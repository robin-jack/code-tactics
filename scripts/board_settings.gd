extends Control

@onready var fakeboard = $VBoxContainer/HBoxContainer1/FakeBoard


const CARD_PLACEHOLDER = preload("res://scenes/prefabs/CardPlaceholder.tscn")
var add_column: bool = false

func _ready():
	for i in Global.num_cards:
		var card_ph = CARD_PLACEHOLDER.instantiate()
		fakeboard.add_child(card_ph)

func _on_button_20_button_up():
	_update_fakeboard(5, 20)

func _on_button_25_button_up():
	_update_fakeboard(5, 25)

func _on_button_30_button_up():
	_update_fakeboard(6, 30)

func _on_button_36_button_up():
	_update_fakeboard(6, 36)

func _update_fakeboard(col, num_cards):
	# Get current cards
	var cards = fakeboard.get_children()
	var current_count = cards.size()

	if current_count < num_cards:
		# Add cards
		for i in range(num_cards - current_count):
			var card_ph = CARD_PLACEHOLDER.instantiate()
			fakeboard.add_child(card_ph)
	elif current_count > num_cards:
		# Remove cards
		for i in range(current_count - num_cards):
			cards[i].queue_free()  # remember queue_free is deferred
			
	fakeboard.set_columns(col)
