extends Upgrade
class_name Bookends

func _init() -> void:
	color = "#FFB300"
	name = "Bookends"
	description = "%s if this letter is both first and last" % TextHelper.mult_string(8)


func on_played(keycap: Keycap, state: Dictionary):
	var word: String = state["word"]
	if word.ends_with(keycap.get_key()) and word.begins_with(keycap.get_key()):
		state["points"] *= 8
