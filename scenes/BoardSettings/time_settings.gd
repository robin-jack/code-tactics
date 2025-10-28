extends PanelContainer

@onready var time_round = $VBoxContainer/TimePerRound
@onready var time_captains = $VBoxContainer/TimeCaptains
@onready var time_soldiers = $VBoxContainer/TimeSoldiers

@onready var single_checkbox = $VBoxContainer/SingleCheckbox
@onready var auto_checkbox = $VBoxContainer/AutoCheckbox
@onready var can_checkbox = $VBoxContainer/CanPauseCheckbox

@export var adv_rect: Rect2 = Rect2(Vector2(1500, 160), Vector2(360, 540))
var original_rect: Rect2

func _ready():
	original_rect = Rect2(position - Vector2(20, 20), size)

func advancify(adv: bool):
	for child in get_tree().get_nodes_in_group("advanced"):
		child.visible = adv
	
func _on_single_checkbox_toggled(toggled_on):
	time_round.visible = toggled_on
	time_captains.visible = !toggled_on
	time_soldiers.visible = !toggled_on
	auto_checkbox.disabled = !toggled_on
	auto_checkbox.button_pressed = !toggled_on

func _exit_tree():
	Settings.game.single_timer = single_checkbox.button_pressed
	Settings.game.auto_start_timer = auto_checkbox.button_pressed
	Settings.game.can_pause_timer = can_checkbox.button_pressed
