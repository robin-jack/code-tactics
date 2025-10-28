extends Control

const BLACK_BG = preload("res://assets/sprites/black_bg.png")
const RED_BG = preload("res://assets/sprites/red_bg.png")
const BLUE_BG = preload("res://assets/sprites/blue_bg.png")

const back: String = "res://scenes/BoardSettings.tscn"
signal transitioned(scn)

@onready var background = $Background
@onready var board = $HBoxContainer/Board
@onready var pcontrols = $HBoxContainer/PlayingControls
@onready var secret_grid = %SecretGrid
@onready var popup_qr = $PopupQR
@onready var show_qr = $ShowQR
@onready var blocker = $Blocker

const TBG := {
	Global.TEAM.RED: RED_BG,
	Global.TEAM.BLUE: BLUE_BG
}

func _ready():
	print("### GAME SURFACE ###")
	await MapManager.new_secret_map()
	var url = await secret_grid.create_secret_grid()
	popup_qr.qr.set_data(url)
	show_qr.disabled = false
	background.texture = TBG[Global.current_team]
	Global.state_changed.connect(_change_background)
	Global.state_changed.connect(_block_input)
	
	print(Settings.game)

func _block_input(state):
	if Global.current_state == Global.STATE.PLAY:
		blocker.visible = false
	else:
		blocker.visible = true

func _change_background(state):
	if state == Global.STATE.NEXT:
		background.texture = TBG[Global.current_team]
	elif state == Global.STATE.OVER:
		background.texture = BLACK_BG

func _on_show_qr_button_up():
	popup_qr.popup.popup_centered()
	popup_qr.margin.custom_minimum_size = Vector2(size.y/1.5, (size.y/1.5)+100)

func _on_back_button_button_up():
	transitioned.emit(back)
