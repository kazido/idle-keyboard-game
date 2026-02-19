extends Node2D

class_name Keycap

@export var name_overwrite: String = ""

@export var is_unlocked: bool = true:
	set(value):
		is_unlocked = value
		_update_visuals()

@export var target_key: Key
@export var alphabetic: bool = true
@onready var label = $Label
@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	_update_label()
	_update_visuals()
	
func _update_label():
	if not is_inside_tree(): return
	# Converts KeyCode to String for the label
	if $Label.text: return
	$Label.text = name_overwrite if name_overwrite else OS.get_keycode_string(target_key)
	
	
func _update_visuals():
	if not is_inside_tree(): return
	# Handle changing the visuals.
	if is_unlocked:
		modulate.a = 1.0
	else:
		modulate.a = 0.1
		
		
func set_light_color(color: Color):
	$Backlight.modulate = color
	
	
func _unhandled_input(event: InputEvent) -> void:
	if not is_unlocked: return # Don't listen to any keys we don't own yet
	if event is InputEventKey and event.keycode == target_key:
		if event.is_echo(): return
		if event.pressed: 
			_on_key_down()
		else:
			_on_key_up()
			
func _on_key_down():
	if alphabetic:
		Global.letter_typed.emit(self)
	
	#sprite.play("pressed")
	#label.scale = Vector2(0.9, 0.9)
	
func _on_key_up():
	pass
	
	#sprite.play("default")
	#label.scale = Vector2(1, 1)
	
	
func is_alphabetic_regex(text: String) -> bool:
	var regex = RegEx.new()
	# ^ means start, $ means end, [a-zA-Z] means only letters
	# Use + to ensure at least one character is present
	regex.compile("^[a-zA-Z]+$") 
	return regex.search(text) != null
		
		
