extends Button

const adv_rect: Rect2 = Rect2(Vector2(600, 860), Vector2(360, 200))
var original_rect: Rect2

func _ready():
	original_rect = Rect2(position, size)
