extends Node

const SAVE_DIR := "user://save/"
const SAVE_NAME := "Settings.tres"
const SAVE_PATH := SAVE_DIR + SAVE_NAME

var game = GameSettings.new()

func _ready():
	verify_save_directory(SAVE_DIR)
	if FileAccess.file_exists(SAVE_PATH):
		_load()

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func _load():
	game = ResourceLoader.load(SAVE_PATH).duplicate(true)
	print_debug("loaded saved settings!")

func save():
	var error = ResourceSaver.save(game, SAVE_PATH)
	if error != OK:
		push_error("Error saving settings: ", error)
	else:
		print("Settings saved successfully!")
