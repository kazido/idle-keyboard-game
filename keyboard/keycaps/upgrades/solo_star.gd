extends Upgrade
class_name SoloStar


func on_played(key: KeyData, state: Dictionary):
	var word: String = state["word"]
	if word.count(key.get_key()) == 1:
		state["points"] *= 5
