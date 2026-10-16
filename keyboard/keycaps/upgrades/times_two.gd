extends Upgrade
class_name TimesTwo


func on_played(_key: KeyData, state: Dictionary):
	state["points"] *= 2
