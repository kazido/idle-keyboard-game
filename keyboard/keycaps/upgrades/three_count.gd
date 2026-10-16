extends Upgrade
class_name ThreeCount


func on_played(key: KeyData, state: Dictionary):
	var word: String = state["word"]
	if word.count(key.get_key()) == 3:
		state["points"] *= 3
