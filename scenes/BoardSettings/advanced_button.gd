extends Button

const adv_rect: Rect2 = Rect2(Vector2(-250, 940), Vector2(500, 100))
var original_rect: Rect2

func _ready():
	original_rect = Rect2(position, size)
