extends Upgrade
class_name BeginsInLetter

func _init() -> void:
	color = "#38d5fc"
	name = "Begins With"
	description = "%s if word starts with this letter" % TextHelper.mult_string(1.5)


func on_played(keycap: Keycap, state: Dictionary):
	if state["word"].begins_with(OS.get_keycode_string(keycap.target_key)):
		state["points"] *= 1.5
