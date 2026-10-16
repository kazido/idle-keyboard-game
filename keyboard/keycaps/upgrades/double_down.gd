extends Upgrade
class_name DoubleDown


func on_played(key: KeyData, state: Dictionary):
	var word: String = state["word"]
	if word.count(key.get_key()) == 2:
		state["points"] *= 2
