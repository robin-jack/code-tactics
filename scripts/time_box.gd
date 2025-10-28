extends TextureButton

@onready var label = $Label
@onready var timer = $Timer
@onready var u_timer = $UpdateTimer
@onready var anim = $CenterContainer/AnimatedSprite2D

var set_time: int = 0

func _ready():
	set_time = Settings.game.tp_round
	timer.wait_time = set_time
	_update(set_time)
	label.pivot_offset = label.size / 2.0
	Global.state_changed.connect(state_changed)
	Global.card_pressed.connect(check_type)

func state_changed(state):
	match state:
		Global.STATE.OVER:
			timer.paused = true
			self.disabled = true

func _update(time_left):
	time_left = int(ceil(time_left))
	var minutes = time_left / 60
	var seconds = time_left % 60
	label.text = str(minutes) + ":" + str(seconds).lpad(2, "0")

func check_type(type):
	if type == Global.TYPE.BLACK:
		# mistake made - stop timer
		print_debug("!!! GAME OVER !!!")
		Global.current_state = Global.STATE.OVER
	elif type != Global.current_team:
		timer.timeout.emit()

func _on_timer_timeout():
	print_debug("Timer timeout called!")
	Global.current_state = Global.STATE.NEXT
	u_timer.stop()
	timer.stop()
	#TODO timer animation
	disabled = true
	_update(set_time)
	await change_label_state(false)
	disabled = false
	
func _on_update_timer_timeout():
	_update(timer.time_left)

func _on_button_up():
	var playing: bool = timer.is_stopped() || timer.paused
	if timer.is_stopped():
		await change_label_state(playing)
		Global.current_state = Global.STATE.PLAY
		u_timer.start()
		timer.start()
	elif Settings.game.can_pause_timer:
			await change_label_state(playing)
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
