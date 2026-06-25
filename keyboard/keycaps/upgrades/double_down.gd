extends Upgrade
class_name DoubleDown

func _init() -> void:
	color = "#4DA3FF"
	name = "Double Down"
	description = "%s if this letter appears exactly 2 times" % TextHelper.mult_string(2)


func on_played(keycap: Keycap, state: Dictionary):
	var word: String = state["word"]
	if word.count(keycap.get_key()) == 2:
		state["points"] *= 2
