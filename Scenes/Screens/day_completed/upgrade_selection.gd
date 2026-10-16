extends CanvasLayer
class_name UpgradeSelectionScreen

signal upgrade_selected # Emitted when an upgrade has been chosen from this screen

const CARD_SCENE := preload("res://scenes/screens/day_completed/upgrade_selection_card.tscn")

func _ready() -> void:
	var pool: Array[Upgrade] = UpgradeRegistry.ALL.duplicate()
	pool.shuffle()
	
	var free_keys := KeyboardModel.free_keys()
	free_keys.shuffle()
	
	for i in mini(3, mini(pool.size(), free_keys.size())):
		var card: UpgradeSelectionCard = CARD_SCENE.instantiate()
		%Upgrades.add_child(card)
		card.setup(pool[i], free_keys[i])
		card.picked.connect(_on_card_picked)

	
func _on_card_picked(upgrade: Upgrade, key: KeyData) -> void:
	key.upgrade = upgrade
	upgrade_selected.emit()
	queue_free()
