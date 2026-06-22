extends Node2D

var test_flat_upgrade = load("res://keyboard/keycaps/upgrades/plus_two.tres")
var test_mult_upgrade = load("res://keyboard/keycaps/upgrades/times_two.tres")


func _ready() -> void:
	randomize()
	var children = $Keycaps.get_children()
	apply_upgrade(children[randi() % children.size()], test_flat_upgrade)
	apply_upgrade(children[randi() % children.size()], test_mult_upgrade)
			
## Apply an upgrade to a keycap
func apply_upgrade(key: Keycap, upgrade: Upgrade):
	for keycap in $Keycaps.get_children():
		if keycap == key:
			keycap.set_upgrade(upgrade)
