extends Control

const back: String = "res://scenes/TitleMenu.tscn"
const next: String = "res://scenes/PlayingControls.tscn"
signal transitioned(scn)

# core settings logic
@onready var number_of_cards = $NumberOfCards
@onready var advanced_button = $AdvancedButton
# fake board logic
@onready var fakeboard = $FakeBoard
@onready var load_board = $LoadBoard
@onready var reset_board = $ResetBoard
# custom words logic
@onready var custom_button = $CustomButton
@onready var popup_qr = $PopupQR
@onready var loading = $Loading

var duration: float = 1
var advanced: bool = false

func _ready():
	number_of_cards.selected.connect(fakeboard.update_fakeboard)
	fakeboard.update_fakeboard(5, 25)

func _on_advanced_button_button_up():
	advanced = !advanced
	show_already_advanced()

func _on_custom_button_button_up():
	custom_button.disabled = true
	advanced_button.disabled = true
	loading.show()
	var url := await FirebaseControl.login()
	loading.hide()
	advanced_button.disabled = false
	custom_button.disabled = false
	if url != "":
		popup_qr.qr.set_data(url)
		popup_qr.popup.popup_centered()
	else:
		print_debug("ERROR NO URL :()")
		

func _on_load_board_button_up():
	load_board.disabled = true
	reset_board.disabled = false

func _on_reset_board_button_up():
	load_board.disabled = false
	reset_board.disabled = true

func _on_back_button_button_up():
	transitioned.emit(back)

func _on_play_button_button_up():
	transitioned.emit(next)

func show_already_advanced():
	advanced_button.disabled = true
	var tw = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
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

const positions_backup: String = '''
Label[P: (526.5, 19.13636), S: (867.0, 122.7273)]
FakeBoard[P: (960.0, 530.0), S: (0.0, 0.0)]
BackButton[P: (810.0, 170.0), S: (300.0, 80.0)]
CustomButton[P: (710.0, 270.0), S: (500.0, 100.0)]
NumberOfCards[P: (590.0, 390.0), S: (360.0, 280.0)]
Time[P: (970.0, 390.0), S: (360.0, 280.0)]
AdvancedButton[P: (710.0, 690.0), S: (500.0, 100.0)]
PlayButton[P: (710.0, 810.0), S: (500.0, 220.0)]
LoadBoard[P: (40.0, 750.0), S: (360.0, 140.0)]
ResetBoard[P: (40.0, 900.0), S: (360.0, 140.0)]
QRCodeRect[P: (420.0, 0.0), S: (1080.0, 1080.0)]
'''
