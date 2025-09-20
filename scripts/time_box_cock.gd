extends TextureButton

@onready var label = $Label
@onready var texture_rect = $TextureRect
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var timer = $Timer
@onready var update_timer = $UpdateTimer

var timecock: int = 30

var started: bool = false

func _ready():
	timer.wait_time = timecock
	update(timecock)

func update(time_left):
	time_left = int(ceil(time_left))
	var minutes = time_left / 60
	var seconds = time_left % 60
	label.text = str(minutes) + ":" + str(seconds).lpad(2, "0")
	_warning_flash(time_left)

func _warning_flash(time_left):
	if time_left <= 60 and time_left % 10 == 0:
		_single_flash()
	if time_left <= 15:
		animation.play("flash", -1, 1.0)
	if time_left <= 10:
		animation.play("flash", -1, 2.0)
	if time_left <= 5:
		animation.play("flash", -1, 4.0)

func _single_flash():
	var tw = get_tree().create_tween()
	tw.tween_property(material, "shader_parameter/enabled", true, 0.0)
	tw.tween_property(material, "shader_parameter/enabled", false, 0.6)

func _on_button_down():
	label.position.y += 1
	texture_rect.position.y += 1

func _on_button_up():
	label.position.y -= 1
	texture_rect.position.y -= 1
	if timer.is_stopped():
		animation.play("start")
		update_timer.start()
		timer.start()
	else:
		if timer.paused:
			timer.paused = false
			update_timer.paused = false
			#texture_rect.texture.region = Rect2(10, 0, 10, 16)
			animation.play("start")
		else:
			timer.paused = true
			update_timer.paused = true
			#texture_rect.texture.region = Rect2(0, 0, 10, 16)
			animation.play("pause")
	
func _on_timer_timeout():
	timer.stop()
	animation.play("pause")
	update(timecock)

func _on_update_timer_timeout():
	update(timer.time_left)
	if timer.is_stopped():
		update_timer.stop()
		animation.stop()
