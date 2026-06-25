extends Upgrade
class_name SoloStar

func _init() -> void:
	color = "#7C4DFF"
	name = "No I In Team"
	description = "%s if this letter appears exactly 1 time" % TextHelper.mult_string(5)


func on_played(keycap: Keycap, state: Dictionary):
	var word: String = state["word"]
	if word.count(keycap.get_key()) == 1:
		state["points"] *= 5
