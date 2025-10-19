extends VBoxContainer

@onready var title = $Label
@onready var time_label = $HBoxContainer/Label

@export var time_per: StringName
@export var title_text: String = "Per Round"
var time: float : set = _set_time
const step: int = 10

func _ready():
	time = Settings.game.get(time_per)
	title.text = title_text
	time_label.text = "%ds" % time

func _set_time(new_time: float):
	time = new_time
	Settings.game.set(time_per, time)

func _on_minus_button_up():
	time -= step
	time_label.text = "%ds" % time

func _on_plus_button_up():
	time += step
	time_label.text = "%ds" % time
