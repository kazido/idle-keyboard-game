extends CanvasLayer

var card_scene = preload("res://Scenes/Screens/UpgradeSelectionCard.tscn")

func _ready():
	GameState.day_ended.connect(_on_day_ended)
	hide()
	

func _on_day_ended(_won: bool):
	var card: UpgradeSelectionCard = card_scene.instantiate()
	%Upgrades.add_child(card)
	card.setup(TimesTwo.new()) # TODO: Randomize
	show()


func upgrade_selected():
	hide()
