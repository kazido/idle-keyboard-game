extends Control

func _ready():
	hide()
	
	
func update_tooltip(keycap: Keycap):
	var kname = keycap.get_key()
	var value = keycap.data.value
	var upgrade = keycap.data.upgrade

	%Keyname.text = kname + " (%s)" % value
	if upgrade:
		var header = "[color=%s]" % upgrade.color.to_html()
		%Upgrade.text = header + upgrade.display_name
		%Description.text = upgrade.get_description()
	else:
		%Upgrade.text = "[color=#999]No Upgrade"
		
		
## Show the tooltip for the keycap based on the mouse position	
func show_for_keycap(keycap):
	update_tooltip(keycap)
	show()
