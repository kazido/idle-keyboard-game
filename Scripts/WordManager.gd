extends Node

signal word_buffer_changed(buffer: Array)
signal word_submitted(buffer: Array)

var buffer: Array[Keycap] = []

## Handles the typing of any key
func type_letter(keycap: Keycap):
	if buffer.size() >= 16:
		return
	buffer.append(keycap)
	# Required to update screen everytime a letter is typed
	emit_signal("word_buffer_changed", buffer)

## Delete one letter from the buffer
func delete_letter():
	if buffer.is_empty():
		return
	buffer.pop_back()
	emit_signal("word_buffer_changed", buffer)

## Validate a word and submit it
func submit_word():
	var word = buffer_to_string(buffer)
	if not ValidWords.is_valid_word(word):
		return
	if word.length() <= 3:
		return
	if GameState.words_used_today.has(word):
		return
	if GameState.words_used_this_week.has(word):
		return
	
	# If all checks pass, submit word
	emit_signal("word_submitted", buffer)
	buffer.clear()
	emit_signal("word_buffer_changed", buffer)
		
## Used to convert an array of Keycaps to a word
func buffer_to_string(buffer_to_convert: Array) -> String:
	var word = ""
	for keycap in buffer_to_convert:
		word += OS.get_keycode_string(keycap.target_key)
	return word
