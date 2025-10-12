extends PanelContainer


@onready var grid_container = $VBoxContainer/GridContainer
@onready var button_36 = $VBoxContainer/GridContainer/Button36

const adv_rect: Rect2 = Rect2(Vector2(20, 160), Vector2(360, 540))
var original_rect: Rect2
signal selected(col, nc)

func _ready():
	original_rect = Rect2(position - Vector2(20, 20), size)

func advancify(adv: bool):
	if adv:
		grid_container.columns = 2
	else:
		grid_container.columns = 3
	button_36.visible = adv
	
func _on_number_of_cards_button_up(col: int, nc: int):
	selected.emit(col, nc)
