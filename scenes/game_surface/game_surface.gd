extends Control

const BLACK_BG = preload("res://assets/sprites/black_bg.png")
const RED_BG = preload("res://assets/sprites/red_bg.png")
const BLUE_BG = preload("res://assets/sprites/blue_bg.png")
signal transitioned(scn)

@onready var background = $Background
@onready var secret_map = %SecretMap

const TBG := {
	Global.TEAM.RED: RED_BG,
	Global.TEAM.BLUE: BLUE_BG
}

func _ready():
	background.texture = TBG[Global.current_team]
	Global.state_changed.connect(_change_background)
	
func _change_background(state):
	if state == Global.STATE.NEXT:
		background.texture = TBG[Global.current_team]
	elif state == Global.STATE.OVER:
		background.texture = BLACK_BG
