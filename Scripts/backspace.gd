extends Keycap


func _unhandled_input(event: InputEvent) -> void:
	if not is_unlocked: return # Don't listen to any keys we don't own yet
	if event is InputEventKey and event.keycode == target_key:
		if event.pressed: 
			_on_key_down()
		else:
			_on_key_up()

func _on_key_down():
	if Global.word_buffer.is_empty(): return
	Global.word_buffer = Global.word_buffer.erase(Global.word_buffer.length() - 1)
