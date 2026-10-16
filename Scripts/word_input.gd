## LOGICAL REPRESENTATION of our typed word. ALL backend
extends Node

signal word_changed(buffer: Array[Keycap], state: WordState)
signal word_submitted(buffer: Array[Keycap])

enum WordState { VALID, USED, INVALID }

var buffer: Array[Keycap] = []


# --- [ BUFFER EDITING METHODS ] ---
func clear_buffer() -> void:
	buffer.clear()
	word_changed.emit(buffer, get_word_state())

func type_letter(keycap) -> void:
	# Maximum word length of 24
	if buffer.size() >= 24:
		return
		
	buffer.append(keycap)
	word_changed.emit(buffer, get_word_state())

func delete_letter():
	if buffer.is_empty():
		return
		
	buffer.pop_back()
	word_changed.emit(buffer, get_word_state())
	
func submit_word() -> void:
	if get_word_state() != WordState.VALID:
		return
		
	# Give signal listeners their own copy of the submitted word
	var submitted_buffer = buffer.duplicate()
	word_submitted.emit(submitted_buffer)
		
func get_word_state() -> WordState:
	var word = get_word_string()
	
	if not ValidWords.is_valid_word(word):
		return WordState.INVALID
	if word.length() <= 2:
		return WordState.INVALID
	if GameState.words_used_today.has(word):
		return WordState.USED	
	if GameState.words_used_this_week.has(word):
		return WordState.USED
	return WordState.VALID
		
func get_word_string() -> String:
	var word = ""
	for keycap in buffer:
		word += keycap.get_key()
	return word
