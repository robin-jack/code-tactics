extends Node

signal card_pressed(type: TYPE)
signal state_changed(state: STATE)

var map: Dictionary
var doc_name: String

var num_cards: int = 25
var columns: int = 5
var max_points: int = 0
var custom_words: bool = false

enum TEAM { RED, BLUE }
enum TYPE { RED, BLUE, BROWN, BLACK}
enum MENU {SETTINGS, SETUP, PLAYING}
enum STATE {NEXT, PLAY, OVER}

const COLOR := {
	TYPE.RED:   Color(0.9, 0.2, 0.2),
	TYPE.BLUE:  Color(0.0, 0.5, 1.0),
	TYPE.BROWN: Color(1.0, 0.7, 0.45),
	TYPE.BLACK: Color(0.1, 0.1, 0.1),
}

var current_team: TEAM
var current_menu: MENU = MENU.SETTINGS
var current_state: STATE = STATE.NEXT

func emit_card(type):
	card_pressed.emit(type)
	var color: Color = COLOR[type]
	return color
	
func set_menu(menu: MENU):
	current_menu = menu
	
func set_state(state: STATE):
	current_state = state
	if state == STATE.NEXT:
		current_team = (current_team + 1) % 2
	state_changed.emit(state)
