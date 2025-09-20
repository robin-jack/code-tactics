extends Control

@onready var button: TextureButton = $Button
@onready var lb1: Label = $Button/Label1
@onready var lb2: Label = $Button/Label2
@onready var anim := $AnimationPlayer

@export var word: String = "Hola"
@export var type: int

var flipped: bool = false

func _ready():
	set_words()
	
func set_words():
	lb1.text = word
	lb2.text = word
	
func _on_button_pressed():
	print("card pressed ", word, " ", type)
	button.disabled = true
	anim.play("flip")

func _on_animation_player_animation_finished(_anim_name):
	button.disabled = false
