extends GridContainer

const CARD_PLACEHOLDER = preload("res://assets/sprites/card_placeholder.png")
const CARD_PLACEHOLDER_SMALL = preload("res://assets/sprites/card_placeholder_small.png")
const CARD = preload("res://scenes/CardFB.tscn")

@onready var cm = %CardMenuPopUp

func _ready():
	cm.replace.connect(_replace_card)
	cm.edit.connect(_edit_card)
	
func _create_placeholder():
	var ph = TextureRect.new()
	if Settings.game.use_small:
		ph.texture = CARD_PLACEHOLDER_SMALL
		ph.size = Vector2(145, 97)
	else:
		ph.texture = CARD_PLACEHOLDER
		ph.size = Vector2(175, 117)
	return ph
		
func update_fakeboard():
	_clear()
	for i in range(Settings.game.num_cards):
		var card_ph = _create_placeholder()
		card_ph.add_to_group("card")
		add_child(card_ph)
	set_columns(Settings.game.col)

func load_board():
	_clear()
	await MapManager.new_secret_map(true)
	var sm = MapManager.secret_map
	for i in range(Settings.game.num_cards):
		var card_fb = CARD.instantiate()
		card_fb.word = sm.keys()[i]
		card_fb.type = sm.values()[i]
		card_fb.menu.connect(_show_card_menu_for)
		add_child(card_fb)
	set_columns(Settings.game.col)

func _show_card_menu_for(card: Control):
	cm.setup_for(card)
	var screen_pos: Vector2
	screen_pos = card.global_position
	screen_pos += Vector2(card.size.x-cm.size.x, -cm.size.y)
	cm.popup(Rect2(screen_pos, Vector2.ZERO))
	cm.set_meta("for_card", card)

func _replace_card(old_card: Control):
	print_debug("replacing card")
	var new_word = MapManager.replace_word(old_card.word)
	_swap_cards(old_card, new_word)

func _edit_card(old_card: Control, new_word: String):
	print_debug("editing card")
	MapManager.edit_word(old_card.word, new_word)
	_swap_cards(old_card, new_word)

func _swap_cards(old_card: Control, new_word: String):
	var new_card = CARD.instantiate()
	new_card.word = new_word
	new_card.type = old_card.type
	new_card.menu.connect(_show_card_menu_for)
	print_debug("SWAPPING")
	await get_tree().process_frame
	add_child(new_card)
	move_child(new_card, old_card.get_index())
	remove_child(old_card)
	old_card.queue_free()
	cm.hide()

func _clear():
	for child in get_tree().get_nodes_in_group("card"):
		if child.get_parent() == self:
			remove_child(child)
			child.queue_free()
