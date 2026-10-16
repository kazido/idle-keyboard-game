extends Upgrade
class_name FinalStand


func on_played(_key: KeyData, state: Dictionary):
	if state["words_remaining"] == 1:
		state["points"] *= 20
