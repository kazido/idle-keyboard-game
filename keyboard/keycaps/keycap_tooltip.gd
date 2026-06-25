extends Control

func _ready():
	hide()
	
	
func _update_tooltip(keycap: Keycap):
	var key_name = OS.get_keycode_string(keycap.target_key)
	var key_value = keycap.value
	%Keyname.text = key_name + " (%s)" % key_value
	if keycap.upgrade:
		var header = "[color=%s]" % keycap.upgrade.color
		%Upgrade.text = header + keycap.upgrade.name
		%Description.text = keycap.upgrade.description
	else:
		%Upgrade.text = "[color=#999]No Upgrade"
		
		
## Show the tooltip for the keycap based on the mouse position	
func show_for_keycap(keycap: Keycap):
	_update_tooltip(keycap)
	show()
