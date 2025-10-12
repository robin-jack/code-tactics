extends Control

const TITLE = preload("res://scenes/TitleMenu.tscn")
const SETUP_CONTROLS = preload("res://scenes/SetupControls.tscn")
const PLAYING_CONTROLS = preload("res://scenes/PlayingControls.tscn")
const BOARD = preload("res://scenes/Board.tscn")

const TITLE_BG = preload("res://assets/sprites/menu_bg.png")
const RED_BG = preload("res://assets/sprites/red_bg.png")
const BLUE_BG = preload("res://assets/sprites/blue_bg.png")
const BLACK_BG = preload("res://assets/sprites/black_bg.png")

const MAP_MANAGER = preload("res://map_manager.gd")

@onready var background = $Background
@onready var mc = %MarginContainer

var mapper: MapManager
var secret_map: Dictionary
var current: Control

func _ready():
	Global.state_changed.connect(change_background)
	current = %MarginContainer/MainMenu
	current.transitioned.connect(transition_to)
	mapper = MAP_MANAGER.new()

func _new_board():
	secret_map = await mapper.create_secret_map()

func transition_to(next_scene: String):
	current.queue_free()
	current = load(next_scene).instantiate()
	mc.add_child(current)
	current.transitioned.connect(transition_to)

func change_background(state: Global.STATE):
	if state == Global.STATE.NEXT:
		if Global.current_team == Global.TEAM.RED:
			background.texture = RED_BG
		else:
			background.texture = BLUE_BG
	elif state == Global.STATE.OVER:
		background.texture = BLACK_BG
