extends PanelContainer

@export var advanced: bool = false
@onready var grid_container = $VBoxContainer/GridContainer
@onready var button_36 = $VBoxContainer/GridContainer/Button36

func _ready():
	if advanced:
		grid_container.columns = 2
		button_36.visible = true
	
