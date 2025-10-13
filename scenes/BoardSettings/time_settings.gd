extends PanelContainer

@onready var time_round = $VBoxContainer/TimePerRound
@onready var time_captains = $VBoxContainer/TimeCaptains
@onready var time_soldiers = $VBoxContainer/TimeSoldiers

@export var adv_rect: Rect2 = Rect2(Vector2(1500, 160), Vector2(360, 540))
var original_rect: Rect2

func _ready():
	original_rect = Rect2(position - Vector2(20, 20), size)

func advancify(adv: bool):
	for child in get_tree().get_nodes_in_group("advanced"):
		child.visible = adv
	
	time_round.visible = !adv
	
func _exit_tree():
	print_debug("Saving Settings")
	#Settings.game.tp_round = time_round.time
	#Settings.game.tp_captains = time_captains.time
	#Settings.game.tp_soldiers = time_soldiers.time
	
