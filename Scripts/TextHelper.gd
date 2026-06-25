extends Node


func format_number(value: float) -> String:
	if value == int(value):
		return str(int(value))
	else:
		return str(value)

func mult_string(amount: float) -> String:
	return "[color=#eb4034][wave]x%s MULT[/wave][/color]" % format_number(amount)
