extends Node

signal word_buffer_changed()
signal word_list_updated(words: Array)
signal score_updated(score: int)
signal required_score_updated(required_score: int)
signal requirement_reached()

var buffer: Array = []
var submitted_words: Array = []
var score: int = 0
var required_score: int = 30


func change_required_score(points: int):
	required_score = points
	emit_signal("required_score_updated", required_score)

func add_score(points: int):
	score += points
	emit_signal("score_updated", score)
	if score >= required_score:
		emit_signal("requirement_reached")

func type_letter(keycap: Keycap):
	if buffer.size() >= 16:
		return
	buffer.append(keycap)
	emit_signal("word_buffer_changed")
	
func delete_letter():
	if buffer.is_empty():
		return
	buffer.pop_back()
	emit_signal("word_buffer_changed")
	
func submit_word():
	if not ValidWords.is_valid_word(_buffer_to_string()):
		return
		
	if buffer.size() <= 3:
		return
		
	for key in buffer:
		add_score(key.value)
		
	submitted_words.append(_buffer_to_string())
	emit_signal("word_list_updated", submitted_words)
	buffer.clear()
	emit_signal("word_buffer_changed")
	
	
func _buffer_to_string() -> String:
	var word = ""
	for keycap in buffer:
		word += OS.get_keycode_string(keycap.target_key)
	return word
		

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	if event.is_action_pressed("backspace", true):
		delete_letter()
		
	if event.is_action_pressed("submit"):
		submit_word()
	
	if event.is_action_pressed("toggle_fullscreen"):
		var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_FULLSCREEN if not is_fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
