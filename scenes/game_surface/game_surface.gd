extends Control

const BLACK_BG = preload("res://assets/sprites/black_bg.png")
const RED_BG = preload("res://assets/sprites/red_bg.png")
const BLUE_BG = preload("res://assets/sprites/blue_bg.png")
signal transitioned(scn)

@onready var background = $Background
@onready var secret_map = %SecretMap

func _ready():
	Global.state_changed.connect(_change_background)
	
func _change_background(state):
	var bg = BLACK_BG
	if state == Global.STATE.NEXT:
		match Global.current_team:
			Global.TEAM.RED:
				bg = RED_BG
			Global.TEAM.BLUE:
				bg = BLUE_BG
	elif state == Global.STATE.OVER:
		bg = BLACK_BG
	background.texture = bg
