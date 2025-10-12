extends BaseBoard

const CARD_PLACEHOLDER = preload("res://assets/sprites/card_placeholder.png")
const CARD_PLACEHOLDER_SMALL = preload("res://assets/sprites/card_placeholder_small.png")

func _ready():
	CARD = preload("res://scenes/CardFB.tscn")
	cm.replace.connect(replace_card)
	cm.edit.connect(edit_card)
	
func _create_placeholder():
	var ph = TextureRect.new()
	if small:
		ph.texture = CARD_PLACEHOLDER_SMALL
		ph.size = Vector2(145, 97)
	else:
		ph.texture = CARD_PLACEHOLDER
		ph.size = Vector2(175, 117)
	return ph
		
func update_fakeboard(col: int, num_cards: int):
	_clear()
	for i in range(num_cards):
		var card_ph = _create_placeholder()
		card_ph.add_to_group("card")
		add_child(card_ph)
	set_columns(col)

func load_board(col: int, num_cards: int):
	_clear()
	mapper = MAP_MANAGER.new(num_cards)
	secret_map = await mapper.create_secret_map()
	for i in range(num_cards):
		var card_fb = CARD.instantiate()
		card_fb.word = secret_map.keys()[i]
		card_fb.type = secret_map.values()[i]
		card_fb.small = small
		card_fb.menu.connect(show_card_menu_for)
		add_child(card_fb)
	set_columns(col)
