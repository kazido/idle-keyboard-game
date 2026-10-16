extends Button
class_name UpgradeSelectionCard

signal picked(upgrade: Upgrade, key: KeyData) # Emitted when this upgrade is chosen

@export var upgrade: Upgrade
var key: KeyData

func _ready() -> void:
	setup(upgrade, KeyData.new(Key.KEY_A))


func setup(new_upgrade: Upgrade, new_key: KeyData) -> void:
	upgrade = new_upgrade
	key = new_key
	%UpgradePlate.color = upgrade.color
	%UpgradeName.text = "[wave][color=%s]%s" % [upgrade.color.to_html(), upgrade.display_name.to_upper()]
	%UpgradeDescription.text = upgrade.get_description()
	%Keycap.text = key.get_key()
	

func _on_pressed() -> void:
	upgrade = upgrade
	picked.emit(upgrade, key)
