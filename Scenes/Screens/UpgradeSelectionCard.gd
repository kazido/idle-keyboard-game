extends ColorRect
class_name UpgradeSelectionCard

var upgrade: Upgrade
var keycap: Keycap
var keyboard: Keyboard

func setup(new_upgrade: Upgrade):
	upgrade = new_upgrade
	%UpgradePlate.color = Color(upgrade.color)
	%UpgradeName.text = "[wave][color=%s]" % new_upgrade.color + new_upgrade.name.to_upper()
	%UpgradeDescription.text = new_upgrade.description
	
	randomize()
	keyboard = get_tree().get_first_node_in_group("keyboard")
	var keycaps = keyboard.get_node("Keycaps").get_children()
	keycap = keycaps[randi() % keycaps.size()]
	# Reselect a keycap if the randomly picked one already has an upgrade
	while keycap.upgrade:
		keycap = keycaps[randi() % keycaps.size()]
	
	%Keycap.text = "Keycap - " + OS.get_keycode_string(keycap.target_key)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		get_tree().paused = false
		keyboard.apply_upgrade(keycap, upgrade)
		GameState.load_next_day()
