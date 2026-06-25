extends Node

signal word_buffer_changed(buffer: Array, valid: WordState)
signal word_submitted(buffer: Array)

enum WordState {VALID, USED, INVALID}

var buffer: Array[Keycap] = []

func clear_buffer() -> void:
	buffer.clear()

## Handles the typing of any key
func type_letter(keycap: Keycap):
	if buffer.size() >= 24:
		return
	buffer.append(keycap)
	emit_signal("word_buffer_changed", buffer)

## Delete one letter from the buffer
func delete_letter():
	if buffer.is_empty():
		return
	buffer.pop_back()
	emit_signal("word_buffer_changed", buffer)
	
	
func validate_word() -> WordState:
	var word = buffer_to_string(buffer)
	if not ValidWords.is_valid_word(word):
		return WordState.INVALID
	if word.length() <= 2:
		return WordState.INVALID
	if GameState.words_used_today.has(word):
		return WordState.USED
	if GameState.words_used_this_week.has(word):
		return WordState.USED
	return WordState.VALID

## Validate a word and submit it
func submit_word():
	if validate_word() != WordState.VALID:
		return
		
	emit_signal("word_submitted", buffer)
	buffer.clear()
	emit_signal("word_buffer_changed", buffer)
		
## Used to convert an array of Keycaps to a word
func buffer_to_string(buffer_to_convert: Array) -> String:
	var word = ""
	for keycap: Keycap in buffer_to_convert:
		word += keycap.get_key()
	return word
