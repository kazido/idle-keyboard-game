extends Upgrade
class_name Bookends


func on_played(key: KeyData, state: Dictionary):
	var word: String = state["word"]
	if word.ends_with(key.get_key()) and word.begins_with(key.get_key()):
		state["points"] *= 8
