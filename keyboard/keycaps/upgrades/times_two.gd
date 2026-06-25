extends Upgrade
class_name TimesTwo

func _init() -> void:
	color = "#a0ff70"
	name = "Times Two"
	description = "%s when used in a word" % TextHelper.mult_string(2)
	# TODO: Fix the color formatting of the name

func on_played(_keycap: Keycap, state: Dictionary):
	state["points"] *= 2
