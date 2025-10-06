extends Button

const adv_rect: Rect2 = Rect2(Vector2(-930, 20), Vector2(300, 80))
var original_rect: Rect2

func _ready():
	original_rect = Rect2(position, size)
