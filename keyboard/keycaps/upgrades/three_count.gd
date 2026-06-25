extends Upgrade
class_name ThreeCount

func _init() -> void:
	color = "#cf69ff"
	name = "Three Count"
	description = "%s if word contains this letter 3 times" % TextHelper.mult_string(3)

func on_played(keycap: Keycap, state: Dictionary):
	var word: String = state["word"]
	if word.count(OS.get_keycode_string(keycap.target_key)) == 3:
		state["points"] *= 3
