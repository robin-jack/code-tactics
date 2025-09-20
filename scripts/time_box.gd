extends Control

@onready var label = $Label
@onready var timer = $Timer
@onready var u_timer = $UpdateTimer
@onready var anim = $CenterContainer/AnimatedSprite2D

var set_time: int = 30

func _ready():
	Global.state_changed.connect(state_changed)
	Global.card_pressed.connect(card_pressed)
	timer.wait_time = set_time
	update(set_time)
	label.pivot_offset = label.size / 2.0

func state_changed(state):
	match state:
		Global.STATE.OVER:
			timer.paused = true
			self.disabled = true

func update(time_left):
	time_left = int(ceil(time_left))
	var minutes = time_left / 60
	var seconds = time_left % 60
	label.text = str(minutes) + ":" + str(seconds).lpad(2, "0")

func card_pressed(type):
	# mistake made - stop timer
	if type == Global.TYPE.BLACK:
		print_debug("!!! GAME OVER !!!")
		Global.set_state(Global.STATE.OVER)
	elif type != Global.current_team:
		timer.timeout.emit()

func _on_timer_timeout():
	print_debug("Timer Timeout called!")
	u_timer.stop()
	timer.stop()
	#TODO timer animation
	update(set_time)
	Global.set_state(Global.STATE.NEXT)
	await change_label_state(false)
	
func _on_update_timer_timeout():
	update(timer.time_left)

func _on_button_up():
	var playing: bool = timer.is_stopped() || timer.paused
	await change_label_state(playing)
	if timer.is_stopped():
		Global.set_state(Global.STATE.PLAY)
		u_timer.start()
		timer.start()
	else:
		if timer.paused:
			timer.paused = false
			u_timer.paused = false
		else:
			timer.paused = true
			u_timer.paused = true

func change_label_state(playing):
	anim.frame = playing
	var tw = get_tree().create_tween().set_parallel(true)
	if playing:
		tw.tween_property(label, "scale", Vector2(1.5, 1.5), 1.0)
		tw.tween_property(label, "position", Vector2(0, label.position.y+50), 1.0)
	else:
		tw.tween_property(label, "scale", Vector2(1, 1), 1.0)
		tw.tween_property(label, "position", Vector2(0, label.position.y-50), 1.0)
	await tw.finished
