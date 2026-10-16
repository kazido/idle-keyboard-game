extends Node


func format_number(value: float) -> String:
	if value == int(value):
		return str(int(value))
	else:
		return str(value)

func mult_string(amount: float) -> String:
	var prefix = "[color=#eb4034][wave freq=%d amp=%d][b]" % [amount, amount]
	var suffix = "[/b][/wave][/color]"
	var middle = "x%s MULT" % format_number(amount)
	return prefix + middle + suffix
