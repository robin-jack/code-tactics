extends GridContainer

const CARD = preload("res://scenes/prefabs/Card.tscn")
const MAP_MANAGER = preload("res://map_manager.gd")

@onready var cm = $CanvasLayer/CardMenuPopUp

var mapper: MapManager
var secret_map: Dictionary

func _ready():
	mapper = MAP_MANAGER.new()
	cm.replace.connect(replace_card)
	cm.edit.connect(edit_card)
	await get_tree().create_timer(1).timeout
	new_board()
	
func new_board():
	#Global.card_selected.emit(null)
	secret_map = await mapper.create_secret_map()
	Global.map = secret_map
	_populate()

func _populate():
	print_debug("Adding cards to BOARD")
	_clear()
	columns = Global.columns
	for i in Global.num_cards:
		var card = CARD.instantiate()
		card.word = secret_map.keys()[i]
		card.type = secret_map.values()[i]
		card.menu.connect(show_card_menu_for)
		add_child(card)
	for card in get_children():
		await get_tree().create_timer(0.1).timeout

func replace_card(old_card: Card):
	print_debug("replacing card")
	var new_word = mapper.replace_word(old_card.word)
	swap_cards(old_card, new_word)

func edit_card(old_card: Card, new_word: String):
	print_debug("editing card")
	mapper.editted_word(old_card.word, new_word)
	swap_cards(old_card, new_word)

func swap_cards(old_card: Card, new_word: String):
	var new_card = CARD.instantiate()
	new_card.word = new_word
	new_card.type = old_card.type
	new_card.menu.connect(show_card_menu_for)
	await get_tree().process_frame
	add_child(new_card)
	move_child(new_card, old_card.get_index())
	remove_child(old_card)
	old_card.queue_free()
	cm.hide()

func show_card_menu_for(card: Card):
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
