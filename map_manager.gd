extends Node

class_name MapManager

const WORDS_FILE = preload("res://words.gd")
const CHAMPIONS_FILE = preload("res://champions.gd")

var words_instance: Node
var selected_words: Array
var selected_code: Array
var secret_map: Dictionary

func _init():
	words_instance = WORDS_FILE.new()

func create_secret_map(recode=true):
	secret_map = {}
	await _new_words()
	if recode:
		_new_code()

	for i in range(selected_words.size()):
		secret_map[selected_words[i]] = selected_code[i]
	
	return secret_map

func replace_word(old_word: String):
	var unique_words = words_instance.WORDS.filter(func(item): return item not in selected_words)
	var new_word = unique_words.pick_random()
	for i in range(selected_words.size()):
		if selected_words[i] == old_word:
			selected_words[i] = new_word
	return new_word

func editted_word(old_word: String, new_word: String) -> void:
	for i in range(selected_words.size()):
		if selected_words[i] == old_word:
			selected_words[i] = new_word

func _new_words():
	# select only words not contained in previous selected words (if any)
	print_debug("Selecting unique words")
	var unique_words = words_instance.WORDS.filter(func(item): return item not in selected_words)
	var custom_words = []
	if Global.custom_words:
		custom_words = await _get_custom_words()
	selected_words = _pick_random_words(Global.num_cards, unique_words, custom_words)

func _new_code():
	print_debug("Creating secret map")
	var one_third = int(floor(Global.num_cards / 3))
	var red_cards = one_third
	var blue_cards = one_third
	var assasin_cards = 1

	var civil_cards = Global.num_cards - (1 + red_cards + blue_cards + assasin_cards)
	# Create the array
	for i in range(red_cards):
		selected_code.append(Global.TYPE.RED)
	for i in range(blue_cards):
		selected_code.append(Global.TYPE.BLUE)
	for i in range(civil_cards):
		selected_code.append(Global.TYPE.BROWN)
	selected_code.append(Global.TYPE.BLACK)
	
	# Ensure there are more 0's than 1's or vice versa randomly
	var starting_team: Global.TEAM
	if randf() < 0.5:
		selected_code.append(Global.TYPE.RED)
		starting_team = Global.TEAM.RED
	else:
		selected_code.append(Global.TYPE.BLUE)
		starting_team = Global.TEAM.BLUE
		
	# Shuffle the array to randomize the order
	Global.current_team = starting_team
	Global.max_points = one_third + 1
	selected_code = _fisher_yates_shuffle(selected_code)

func _get_custom_words():
	var rooms = "pass"
	var document = await rooms.get_doc(Global.doc_name)
	
	if(document == null):
		print_debug("Failed to get Document")
		return
	
	# Extract the words
	var custom_words = await document.get_value("words")
	return custom_words

func _pick_random_words(count: int, words: Array, custom_words: Array) -> Array:
	# process custom words
	if not custom_words.is_empty():
		# replace default words with custom words
		custom_words.shuffle()
		if Global.mix:
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
