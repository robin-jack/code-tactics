extends Button

const adv_rect: Rect2 = Rect2(Vector2(600, 720), Vector2(360, 120))
var original_rect: Rect2

func _ready():
	original_rect = Rect2(position, size)
