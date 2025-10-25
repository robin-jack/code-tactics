extends GridContainer

const CARD = preload("res://scenes/prefabs/Card.tscn")

func populate():
	var sm = MapManager.secret_map
	print(sm.keys()[0])
	print(sm.keys()[1])
	print_debug("Adding cards to BOARD")
	_clear()
	columns = Settings.game.col
	for i in Settings.game.num_cards:
		var card = CARD.instantiate()
		card.word = sm.keys()[i]
		card.type = sm.values()[i]
		add_child(card)
	for card in get_children():
		await get_tree().create_timer(0.1).timeout

func _clear():
	for child in get_children():
		remove_child(child)
		child.queue_free()
