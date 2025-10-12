extends BaseBoard

const CARD_PH = preload("res://assets/sprites/card_placeholder.png")
const CARD_PH_SMALL = preload("res://assets/sprites/card_placeholder_small.png")

var card_texture: Texture = CARD_PH

func create_placeholder():
	var card = TextureRect.new()
	card.texture = card_texture
	if card_texture == CARD_PH_SMALL:
		card.size = Vector2(140, 94)
	else:
		card.size = Vector2(200, 133)
	return card

func update_fakeboard(col: int, num_cards: int):
	var tex = CARD_PH_SMALL if col > 5 else CARD_PH
	for child in get_children():
		child.queue_free()
	card_texture = tex
	for i in range(num_cards):
		var card_ph = create_placeholder()
		add_child(card_ph)
			
	set_columns(col)
