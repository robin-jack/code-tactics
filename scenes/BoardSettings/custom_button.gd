extends Button

const adv_rect: Rect2 = Rect2(Vector2(1500, 730), Vector2(360, 100))
var original_rect: Rect2

func _ready():
	original_rect = Rect2(position - Vector2(20, 20), size)
