extends Node

var valid_words: Dictionary = {}

func _ready():
	load_word_list()

func load_word_list():
	var file = FileAccess.open("res://scripts/words_alpha.txt", FileAccess.READ)
	if file == null:
		push_error("Could not open word list!")
		return
	while not file.eof_reached():
		var word = file.get_line().strip_edges().to_lower()
		if word != "":
			valid_words[word] = true
	file.close()

func is_valid_word(word: String) -> bool:
	return valid_words.has(word.to_lower())
