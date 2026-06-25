extends Node2D

class_name Keycap

@export var target_key: Key
@export var name_overwrite: String = ""
@export var alphabetic: bool = true
@onready var label = $Label
@onready var sprite = $AnimatedSprite2D

@export var is_unlocked: bool = true
@export var upgrade: Upgrade
var value: int = 1


func _ready() -> void:
	$Label.text = name_overwrite if name_overwrite else OS.get_keycode_string(target_key)
	if not is_unlocked: modulate.a = 0.1
		
func set_light_color(color: Color):
	$Backlight.modulate = color

## Set the keycaps upgrade
func set_upgrade(new_upgrade: Upgrade):
	new_upgrade.on_applied(self)
	upgrade = new_upgrade
			

func _unhandled_input(event: InputEvent) -> void:
	if not is_unlocked: return # Don't listen to any keys we don't own yet
	if event.is_echo(): return # Ignore echoing keys
	if event is InputEventKey and event.keycode == target_key:
		if event.is_pressed():
			if alphabetic: WordManager.type_letter(self)
			
					
func _on_area_2d_mouse_entered() -> void:
	%UpgradeCard.show_for_keycap(self)
	
func _on_area_2d_mouse_exited() -> void:
	%UpgradeCard.hide()
