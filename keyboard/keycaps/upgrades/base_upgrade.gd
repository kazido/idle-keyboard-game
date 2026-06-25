extends Resource
class_name Upgrade

var name: String
var description: String
var color: String

func on_applied(keycap: Keycap) -> void:
	keycap.set_light_color(Color(color))
	
func on_played(_keycap: Keycap, _state: Dictionary):
	pass # Overridden
