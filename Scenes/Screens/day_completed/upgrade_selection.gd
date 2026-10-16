extends CanvasLayer
class_name UpgradeSelectionScreen

signal upgrade_selected # Emitted when an upgrade has been chosen from this screen

var card_scene = preload("res://scenes/screens/day_completed/upgrade_selection_card.tscn")

var upgrades := [
	TimesTwo, 
	BeginsInLetter, 
	EndsInLetter,
	ThreeCount,
	DoubleDown,
	SoloStar,
	Bookends,
	FinalStand,
	]

func _ready():
	for i in range(3):
		var card = card_scene.instantiate()
		%Upgrades.add_child(card)
		card.setup(select_random_upgrade())
		
		card.picked.connect(_on_card_picked)
	
func select_random_upgrade() -> Upgrade:
	randomize()
	return upgrades[randi() % upgrades.size()].new()
	
func _on_card_picked() -> void:
	upgrade_selected.emit()
	queue_free()
