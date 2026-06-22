extends Node
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	if event.is_action_pressed("backspace", true):
		WordManager.delete_letter()
		
	if event.is_action_pressed("submit"):
		WordManager.submit_word()
	
	if event.is_action_pressed("toggle_fullscreen"):
		var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_FULLSCREEN if not is_fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
