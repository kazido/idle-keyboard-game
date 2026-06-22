extends Node2D

class_name Keycap

@export var target_key: Key
@export var name_overwrite: String = ""
@export var alphabetic: bool = true
@onready var label = $Label
@onready var sprite = $AnimatedSprite2D

@export var is_unlocked: bool = true
@export var _upgrade: Upgrade
var _value: int = 1


func _ready() -> void:
	$Label.text = name_overwrite if name_overwrite else OS.get_keycode_string(target_key)
	if not is_unlocked: modulate.a = 0.1
		
		
func set_light_color(color: Color):
	$Backlight.modulate = color
	
	
## Get the value of the keycap after upgrades are applied
func get_value() -> int:
	if _upgrade and _upgrade.upgrade_type == Upgrade.UpgradeType.FLAT:
		return int(_value + _upgrade.amount)
	return _value
	
## Get the multiplier value of the keycap after upgrades are applied
func get_multiplier() -> float:
	if _upgrade and _upgrade.upgrade_type == Upgrade.UpgradeType.MULTIPLIER:
		return _upgrade.amount
	return 1


## Set the keycaps upgrade
func set_upgrade(upgrade: Upgrade):
	_upgrade = upgrade
	if upgrade.upgrade_type == Upgrade.UpgradeType.MULTIPLIER:
			set_light_color(Color.RED)
	elif upgrade.upgrade_type == Upgrade.UpgradeType.FLAT:
			set_light_color(Color.AQUA)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if not is_unlocked: return # Don't listen to any keys we don't own yet
	if event.is_echo(): return # Ignore echoing keys
	if event is InputEventKey and event.keycode == target_key:
		if event.is_pressed():
			if alphabetic: WordManager.type_letter(self)
		
		
