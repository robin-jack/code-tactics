extends PanelContainer

@onready var time_per_round = $VBoxContainer/TimePerRound

@export var adv_rect: Rect2 = Rect2(Vector2(1500, 160), Vector2(360, 540))
var original_rect: Rect2

func _ready():
	original_rect = Rect2(position - Vector2(20, 20), size)

func advancify(adv: bool):
	for child in get_tree().get_nodes_in_group("advanced"):
		child.visible = adv
	
	time_per_round.visible = !adv
