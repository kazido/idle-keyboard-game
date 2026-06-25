extends Upgrade
class_name EndsInLetter

func _init() -> void:
	color = "#389afc"
	name = "Ends With"
	description = "%s if word ends with this letter" % TextHelper.mult_string(4)


func on_played(keycap: Keycap, state: Dictionary):
	if state["word"].ends_with(OS.get_keycode_string(keycap.target_key)):
		state["points"] *= 4
