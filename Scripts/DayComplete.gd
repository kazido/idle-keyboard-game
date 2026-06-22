extends CanvasLayer

func _ready() -> void:
	GameState.connect("day_ended", _on_day_ended)
	
func _on_day_ended(won: bool):
	if won:
		self.visible = true
		get_tree().paused = true

func _on_button_pressed() -> void:
	self.visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()
