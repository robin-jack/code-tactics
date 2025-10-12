extends Button

@export var adv_rect: Rect2 = Rect2(Vector2(695, 940), Vector2(500, 80))
var original_rect: Rect2

func _ready():
	original_rect = Rect2(position - Vector2(20, 20), size)
