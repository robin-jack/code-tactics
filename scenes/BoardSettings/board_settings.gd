extends Control

const CARD_PH = preload("res://assets/sprites/card_placeholder.png")
const CARD_PH_SMALL = preload("res://assets/sprites/card_placeholder_small.png")

@onready var number_of_cards = $NumberOfCards
@onready var time = $Time
@onready var advanced_button = $AdvancedButton
@onready var fakeboard = $FakeBoard
@onready var load_board = $LoadBoard
@onready var reset_board = $ResetBoard

var duration: float = 1
var advanced: bool = false
var card_texture: Texture = CARD_PH

func _ready():
	number_of_cards.selected.connect(_update_fakeboard)
	_update_fakeboard(5, 25)

func _on_advanced_button_button_up():
	advanced = !advanced
	show_already_advanced()
		
func create_placeholder():
	var card = TextureRect.new()
	card.texture = card_texture
	if card_texture == CARD_PH_SMALL:
		card.size = Vector2(140, 94)
	else:
		card.size = Vector2(200, 133)
	return card

func _update_fakeboard(col: int, num_cards: int):
	var tex = CARD_PH_SMALL if col > 5 else CARD_PH
	for child in fakeboard.get_children():
		child.queue_free()
	card_texture = tex
	for i in range(num_cards):
		var card_ph = create_placeholder()
		fakeboard.add_child(card_ph)
			
	fakeboard.set_columns(col)

func show_already_advanced():
	advanced_button.disabled = true
	var tw = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.stop()
	var color = Color.WHITE if advanced else Color.TRANSPARENT
	var targets = get_tree().get_nodes_in_group("already_adv")
	for target in targets:
		tw.tween_property(target, "modulate", color, duration*0.5)
	if advanced:
		await tween_to_target().finished
		get_tree().call_group("already_adv", "show")
		tw.play()
		advanced_button.text = "SHOW LESS"
	if not advanced:
		tw.play()
		await tw.finished
		get_tree().call_group("already_adv", "hide")
		await tween_to_target().finished
		advanced_button.text = "ADVANCED SETTINGS"
	advanced_button.disabled = false
	

func tween_to_target():
	var targets = get_tree().get_nodes_in_group("adv_node")
	var tw = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	for target in targets:
		if target.has_method("advancify"):
			target.advancify(advanced)
		var rect: Rect2 = target.adv_rect if advanced else target.original_rect
		tw.tween_property(target, "position", rect.position, duration)
		tw.tween_property(target, "size",     rect.size,     duration)
	
	return tw

func _on_load_board_button_up():
	load_board.disabled = true
	reset_board.disabled = false

func _on_reset_board_button_up():
	load_board.disabled = false
	reset_board.disabled = true
