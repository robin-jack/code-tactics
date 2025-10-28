extends Node

const WORDS_FILE = preload("res://words.gd")
const CHAMPIONS_FILE = preload("res://champions.gd")

signal map_created

var _num_cards: int = 0
var _words_instance: Node = null
var _selected_words: Array = []
var _selected_code: Array = []

## Dictionary of structure: [Words: Types]
var secret_map: Dictionary = {}

func _init():
	_words_instance = WORDS_FILE.new()
	_num_cards = Settings.game.num_cards

## Creates a new Secret Map. Needs to be AWAITED
func new_secret_map(force: bool = false):
	if secret_map.is_empty() || force:
		print_debug("CREATING NEW MAP")
		await _create_secret_map()
	map_created.emit()

## Changes which words file to load
func change_words_file_to_(path: StringName):
	_words_instance = load(path).new()
	
## Returns a new Secret Map
func _create_secret_map(recode=true):
	secret_map = {}
	_num_cards = Settings.game.num_cards
	await _new_words()
	if recode:
		_new_code()
	# here is where the secret map is SET
	for i in range(_selected_words.size()):
		secret_map[_selected_words[i]] = _selected_code[i]
		
func replace_word(old_word: String):
	var unique_words = _words_instance.WORDS.filter(func(item): return item not in _selected_words)
	var new_word = unique_words.pick_random()
	swap_word_mantain_order(old_word, new_word)
	return new_word

func edit_word(old_word: String, new_word: String) -> void:
	swap_word_mantain_order(old_word, new_word)

func swap_word_mantain_order(old_word: String, new_word: String) -> void:
	for i in range(_selected_words.size()):
		if _selected_words[i] == old_word:
			print("snatched old word")
			_selected_words[i] = new_word
			print("set it to: ", _selected_words[i])
	# map being set here
	print("making change in secret map")
	secret_map = {}
	for i in range(_selected_words.size()):
		secret_map[_selected_words[i]] = _selected_code[i]

func _new_words():
	# select only words not contained in previous selected words (if any)
	print_debug("Selecting unique words")
	var unique_words = _words_instance.WORDS.filter(func(item): return item not in _selected_words)
	var custom_words = []
	if Settings.game.custom_words:
		custom_words = await _get_custom_words()
	_selected_words = _pick_random_words(_num_cards, unique_words, custom_words)

func _new_code():
	print_debug("Creating secret map")
	var one_third = int(floor(_num_cards / 3))
	var red_cards = one_third
	var blue_cards = one_third
	var assasin_cards = 1

	var civil_cards = _num_cards - (1 + red_cards + blue_cards + assasin_cards)
	# Create the array
	for i in range(red_cards):
		_selected_code.append(Global.TYPE.RED)
	for i in range(blue_cards):
		_selected_code.append(Global.TYPE.BLUE)
	for i in range(civil_cards):
		_selected_code.append(Global.TYPE.BROWN)
	_selected_code.append(Global.TYPE.BLACK)
	
	# Ensure there are more 0's than 1's or vice versa randomly
	var starting_team: Global.TEAM
	if randf() < 0.5:
		_selected_code.append(Global.TYPE.RED)
		starting_team = Global.TEAM.RED
	else:
		_selected_code.append(Global.TYPE.BLUE)
		starting_team = Global.TEAM.BLUE
		
	# Shuffle the array to randomize the order
	Global.current_team = starting_team
	Global.max_points = one_third + 1
	_selected_code = _fisher_yates_shuffle(_selected_code)

func _get_custom_words():
	var rooms = FirebaseControl.rooms
	var document = await rooms.get_doc(FirebaseControl.doc_name)
	
	if(document == null):
		print_debug("Failed to get Document (could not access it)")
		return []
	
	# Extract the words
	var custom_words = await document.get_value("words")
	print(custom_words)
	print(typeof(custom_words))
	return custom_words if custom_words is Array else []

func _pick_random_words(count: int, words: Array, custom_words: Array) -> Array:
	# process custom words
	if not custom_words.is_empty():
		# replace default words with custom words
		custom_words.shuffle()
		if Settings.game.mix_words:
			if custom_words.size() >= count/2:
				print_debug("Mixing words with half of custom")
				custom_words = custom_words.slice(0, count/2)
			else:
				print_debug("Mixing words with custom")
			count -= custom_words.size()
		else:
			if custom_words.size() >= count:
				print_debug("Only using custom, bigger than words")
				words = custom_words
				custom_words = []
			else:
				print_debug("Only using custom, have to fill gap with words")
				count -= custom_words.size()
	else:
		print_debug("Did not use custom words as it was empty")

	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var indices = []
	while indices.size() < count:
		var index = int(rng.randf() * words.size())
		if !indices.has(index):
			indices.append(index)

	var random_picked_words = []
	for index in indices:
		random_picked_words.append(words[index])
	
	if not custom_words.is_empty():
		random_picked_words.append_array(custom_words)
		random_picked_words.shuffle()
		
	#print_debug(random_picked_words)
	return random_picked_words

func _fisher_yates_shuffle(array: Array) -> Array:
	var n = array.size()
	for i in range(n - 1, 0, -1):
		var j = randi() % (i + 1)
		# Swap elements at index i and j
		var temp = array[i]
		array[i] = array[j]
		array[j] = temp
	return array
