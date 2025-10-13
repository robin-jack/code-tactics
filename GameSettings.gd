class_name GameSettings extends Resource

# board
@export var num_cards: int = 25
@export var col: int = 5 : set = _set_col
@export var use_small: bool = false
@export var custom_words: bool = false
@export var mix_words: bool = false

# time
@export var one_timer: bool = true
@export var tp_round: float = 180
@export var tp_captains: float = 120
@export var tp_soldiers: float = 60
@export var self_start_timer: bool = false

func _set_col(new_col: int):
	col = new_col
	if col > 5:
		use_small = true
	else:
		use_small = false
