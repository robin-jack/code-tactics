extends GridContainer

class_name BaseBoard

const MAP_MANAGER = preload("res://map_manager.gd")

@onready var cm = %CardMenuPopUp

var mapper: MapManager
var secret_map: Dictionary

var CARD: PackedScene
var small: bool = false

func replace_card(old_card: Control):
	print_debug("replacing card")
	var new_word = mapper.replace_word(old_card.word)
	swap_cards(old_card, new_word)

func edit_card(old_card: Control, new_word: String):
	print_debug("editing card")
	mapper.editted_word(old_card.word, new_word)
	swap_cards(old_card, new_word)

func swap_cards(old_card: Control, new_word: String):
	var new_card = CARD.instantiate()
	new_card.word = new_word
	new_card.type = old_card.type
	new_card.small = small
	new_card.menu.connect(show_card_menu_for)
	print_debug("SWAPPING")
	await get_tree().process_frame
	add_child(new_card)
	move_child(new_card, old_card.get_index())
	remove_child(old_card)
	old_card.queue_free()
	cm.hide()

func show_card_menu_for(card: Control):
	cm.setup_for(card)
	var screen_pos: Vector2
	screen_pos = card.global_position
	screen_pos += Vector2(card.size.x-cm.size.x, -cm.size.y)
	cm.popup(Rect2(screen_pos, Vector2.ZERO))
	cm.set_meta("for_card", card)

func _clear():
	for child in get_tree().get_nodes_in_group("card"):
		remove_child(child)
		child.queue_free()
