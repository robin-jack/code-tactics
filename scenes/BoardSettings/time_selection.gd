extends VBoxContainer

@onready var title = $Label
@onready var time = $HBoxContainer/Label

@export var title_text: String = "Per Round"
@export var initial_seconds: int = 120
const step: int = 10

func _ready():
	title.text = title_text
	time.text = "%ds" % initial_seconds

func _on_minus_button_up():
	time.text = "%ds" % (int(time.text) - step)

func _on_plus_button_up():
	time.text = "%ds" % (int(time.text) + step)
