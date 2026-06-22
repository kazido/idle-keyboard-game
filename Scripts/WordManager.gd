extends Node

signal word_buffer_changed(buffer: Array)
signal word_submitted(buffer: Array)

var buffer: Array = []

func type_letter(keycap: Keycap):
	if buffer.size() >= 16:
		return
	buffer.append(keycap)
	emit_signal("word_buffer_changed", buffer)
	
func delete_letter():
	if buffer.is_empty():
		return
	buffer.pop_back()
	emit_signal("word_buffer_changed", buffer)
	
func submit_word():
	var word = buffer_to_string(buffer)
	if not ValidWords.is_valid_word(word):
		print("Invalid word.")
		return
		
	if word.length() <= 3:
		print("Word too short.")
		return
		
	if GameState.words_used_today.has(word):
		print("Already used today.")
		return
		
	if GameState.words_used_this_week.has(word):
		print("Already used earlier in the week.")
		return
		
	emit_signal("word_submitted", buffer)
	buffer.clear()
	emit_signal("word_buffer_changed", buffer)
	return
		
func buffer_to_string(buffer_to_convert: Array) -> String:
	var word = ""
	for keycap in buffer_to_convert:
		word += OS.get_keycode_string(keycap.target_key)
	return word
