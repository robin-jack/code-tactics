extends Control

const SETUP_CONTROLS = preload("res://scenes/SetupControls.tscn")
const PLAYING_CONTROLS = preload("res://scenes/PlayingControls.tscn")

const MENU_BG = preload("res://assets/sprites/menu_bg.png")
const RED_BG = preload("res://assets/sprites/red_bg.png")
const BLUE_BG = preload("res://assets/sprites/blue_bg.png")
const BLACK_BG = preload("res://assets/sprites/black_bg.png")

@onready var hbox = $MarginContainer/HBoxContainer
@onready var board = $MarginContainer/HBoxContainer/Board
@onready var background = $Background

var setup: Control
var playing: Control

func _ready():
	Global.state_changed.connect(change_background)
	instantiate_setup()

func instantiate_setup():
	setup = SETUP_CONTROLS.instantiate()
	setup.to_playing.connect(_on_setup_to_playing)
	setup.reload.connect(board.new_board)
	hbox.add_child(setup)
	hbox.move_child(setup, 0)

func _on_setup_to_playing():
	change_background(Global.STATE.NEXT)
	setup.queue_free()
	playing = PLAYING_CONTROLS.instantiate()
	playing.to_setup.connect(_on_playing_to_setup)
	hbox.add_child(playing)
	
func _on_playing_to_setup():
	background.texture = MENU_BG
	playing.queue_free()
	instantiate_setup()

func change_background(state: Global.STATE):
	if state == Global.STATE.NEXT:
		if Global.current_team == Global.TEAM.RED:
			background.texture = RED_BG
		else:
			background.texture = BLUE_BG
	elif state == Global.STATE.OVER:
		background.texture = BLACK_BG
