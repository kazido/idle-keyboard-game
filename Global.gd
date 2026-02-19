extends Node

signal money_changed(new_amount)
signal letter_typed(letter)
signal word_submitted()


var money: int = 0:
	set(value):
		money = value
		money_changed.emit(money)

var word_buffer: String = ""


func _ready() -> void:
	connect("letter_typed", _on_letter_typed)
	connect("word_submitted", _on_word_submitted)
	
			
func _on_letter_typed(keycap: Keycap) -> void:
	word_buffer = word_buffer + OS.get_keycode_string(keycap.target_key)
	
func _on_word_submitted() -> void:
	word_buffer = ""
		

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if event.is_action_pressed("toggle_fullscreen"):
		var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_FULLSCREEN if not is_fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
