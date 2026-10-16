extends Label
class_name LetterDisplay

func set_letter(key: KeyData, color: Color) -> void:
	text = key.get_key()
	add_theme_font_size_override("font_size", 40)
	add_theme_color_override("font_color", color)
	
func bounce(height: float = 20.0):
	var tween = create_tween()
	tween.tween_property(self, "position:y", -height, 0.1)\
		.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", 0, 0.1)\
		.set_trans(Tween.TRANS_BOUNCE)
		
func slam(intensity: float):
	bounce(intensity * 5)
	
