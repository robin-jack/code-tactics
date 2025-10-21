extends TextureRect

@export var team: Global.TEAM
@onready var label = $Label

var points = 0
var max_points = 0

const TNAME := {
	0: "RED",
	1: "BLUE"
}

func _ready():
	if Global.current_team == team:
		max_points = Global.max_points
	else:
		max_points = Global.max_points - 1
	label.text = "%d/%d" % [points, max_points]
	Global.card_pressed.connect(update_points)
	
func update_points(type: Global.TYPE):
	if type == team:
		#TODO success animation
		points += 1
		label.text = "%d/%d" % [points, max_points]
		check_win()
	else:
		#TODO mistake animation
		pass

func check_win():
	if points == max_points:
		Global.set_state(Global.STATE.OVER)
		print_debug(TNAME[team], " TEAM WON !!!")
