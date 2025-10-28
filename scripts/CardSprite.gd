extends Control

@onready var flip = $FlipTexture
@onready var button: TextureButton = $Button
@onready var lb1: Label = $Button/Label1
@onready var lb2: Label = $Button/Label2
@onready var anim = $AnimationPlayer

@export var word: String = "mmmmeee"
@export var type: int = 0

var flipped: bool = true

signal menu(card)

func _ready():
	set_words()
	await get_tree().process_frame
	_center_text()
	
func _center_text():
	# font_size = 5 + (7000 / size.x)
	if lb1.size.x > 335:
		lb1.add_theme_font_size_override("font_size", 23)
		lb2.add_theme_font_size_override("font_size", 23)
	elif lb1.size.x > 255:
		lb1.add_theme_font_size_override("font_size", 31)
		lb2.add_theme_font_size_override("font_size", 31)
	elif lb1.size.x > 200:
		lb1.add_theme_font_size_override("font_size", 40)
		lb2.add_theme_font_size_override("font_size", 40)
	# default "font_size": 50
	await get_tree().process_frame
	lb1.pivot_offset = lb1.size / 2.0
	lb2.pivot_offset = lb2.size / 2.0
	
func set_words():
	lb1.text = word
	lb2.text = word
	
func _on_button_pressed():
	#if Global.current_state == Global.STATE.PLAY:
	button.disabled = true
	anim.play("flip")
	button.self_modulate = Global.emit_card(type)

func _on_animation__finished(_anim_name):
	flipped = !flipped
