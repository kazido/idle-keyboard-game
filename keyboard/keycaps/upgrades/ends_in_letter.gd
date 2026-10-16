extends Upgrade
class_name EndsInLetter


func on_played(key: KeyData, state: Dictionary):
	if state["word"].ends_with(key.get_key()):
		state["points"] *= 4
