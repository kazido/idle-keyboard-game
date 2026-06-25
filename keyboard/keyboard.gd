extends Node2D
class_name Keyboard


func _ready() -> void:
	add_to_group("keyboard")
	for key_name in GameState.keycap_upgrades:
		var keycap = find_keycap_by_letter(key_name)
		if keycap:
			apply_upgrade(keycap, GameState.keycap_upgrades[key_name])
			
## Apply an upgrade to a keycap
func apply_upgrade(keycap: Keycap, upgrade: Upgrade):
	var key_name = OS.get_keycode_string(keycap.target_key)
	GameState.keycap_upgrades[key_name] = upgrade
	keycap.set_upgrade(upgrade)


func find_keycap_by_letter(letter: String) -> Keycap:
	for keycap: Keycap in $Keycaps.get_children():
		if  OS.get_keycode_string(keycap.target_key) == letter:
			return keycap
	return null
