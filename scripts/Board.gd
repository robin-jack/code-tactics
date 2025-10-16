extends GridContainer

const CARD = preload("res://scenes/prefabs/Card.tscn")

var mapper: MapManager
var secret_map: Dictionary

func _ready():
	mapper = Global.get_map_manager()
	secret_map = await mapper.get_map()
	await get_tree().create_timer(1).timeout
	_populate()

func _populate():
	print_debug("Adding cards to BOARD")
	_clear()
	columns = Settings.game.col
	for i in Settings.game.num_cards:
		var card = CARD.instantiate()
		card.word = secret_map.keys()[i]
		card.type = secret_map.values()[i]
		add_child(card)
	for card in get_children():
		await get_tree().create_timer(0.1).timeout

func _clear():
	for child in get_children():
		remove_child(child)
		child.queue_free()
