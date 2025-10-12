extends BaseBoard

func _ready():
	CARD = preload("res://scenes/prefabs/Card.tscn")
	cm.replace.connect(replace_card)
	cm.edit.connect(edit_card)
	mapper = MAP_MANAGER.new(25)
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
