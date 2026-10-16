extends Upgrade
class_name BeginsInLetter


func on_played(key: KeyData, state: Dictionary):
	if state["word"].begins_with(key.get_key()):
		state["points"] *= 1.5
