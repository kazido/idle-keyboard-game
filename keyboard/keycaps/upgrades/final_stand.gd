extends Upgrade
class_name FinalStand

func _init() -> void:
	color = "#7C4DFF"
	name = "Final Stand"
	description = "%s if this in the last word of the day" % TextHelper.mult_string(20)


func on_played(_keycap: Keycap, state: Dictionary):
	if state["words_remaining"] == 1:
		state["points"] *= 20
