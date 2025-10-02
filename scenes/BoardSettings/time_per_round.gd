extends PanelContainer

@export var advanced: bool = false

@onready var time_per_round = $VBoxContainer/TimePerRound

func _ready():
	if advanced:
		for child in get_tree().get_nodes_in_group("advanced"):
			child.visible = true
		
		time_per_round.visible = false
