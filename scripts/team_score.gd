extends TextureRect

@export var team: Global.TEAM
@onready var label = $Label

var points = 0
var max_points = 0

func _ready():
	if Global.current_team == team:
		max_points = Global.max_points
	else:
		max_points = Global.max_points - 1
	Global.card_pressed.connect(update_points)
	label.text = "%d/%d" % [points, max_points]
	
func update_points(type: Global.TYPE):
	if type == team:
		#TODO success animation
		points += 1
		label.text = "%d/%d" % [points, max_points]
	else:
		#TODO mistake animation
		pass
