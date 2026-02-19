extends Keycap


func _on_key_down():
	Global.word_submitted.emit()
