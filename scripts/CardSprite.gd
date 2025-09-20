extends Control

class_name  Card

@onready var flip = $FlipTexture
@onready var button: TextureButton = $Button
@onready var lb1: Label = $Button/Label1
@onready var lb2: Label = $Button/Label2
@onready var anim = $AnimationPlayer

@export var word: String = "electroencefalogra"
@export var type: int = 0

var flipped: bool = true
signal menu(card)

func _ready():
	set_words()
	await get_tree().process_frame
	_center_text()
	
func _center_text():
	if lb1.size.x > 335:
		lb1.add_theme_font_size_override("font_size", 25)
		lb2.add_theme_font_size_override("font_size", 25)
	elif lb1.size.x > 255:
		lb1.add_theme_font_size_override("font_size", 30)
		lb2.add_theme_font_size_override("font_size", 30)
	elif lb1.size.x > 200:
		lb1.add_theme_font_size_override("font_size", 40)
		lb2.add_theme_font_size_override("font_size", 40)
	await get_tree().process_frame
	lb1.pivot_offset = lb1.size / 2.0
	lb2.pivot_offset = lb2.size / 2.0
	
func set_words():
	lb1.text = word
	lb2.text = word
	
func _on_button_pressed():
	if Global.current_menu == Global.MENU.SETUP:
		menu.emit(self)
	elif Global.current_menu == Global.MENU.PLAYING:
		if Global.current_state == Global.STATE.PLAY:
			button.disabled = true
			anim.play("flip")
			button.self_modulate = Global.emit_card(type)

func _on_animation__finished(_anim_name):
	flipped = !flipped
