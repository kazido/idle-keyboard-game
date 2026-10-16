extends Node2D
class_name Keycap

var data: KeyData

@export var target_key: Key
@export var name_overwrite: String = ""
@export var alphabetic: bool = true

@onready var label = $Label
@onready var sprite = $AnimatedSprite2D

@export var is_unlocked: bool = true

var _flash_tween: Tween
var _press_tween: Tween


func _ready() -> void:
	data = KeyboardModel.get_key(target_key)
	refresh()

	# Puts the labels on the keys the first time they load
	$Label.text = name_overwrite if name_overwrite else get_key()

func _rest_color() -> Color:
	if data.upgrade:
		return Color(data.upgrade.color)
	return Color.TRANSPARENT

func refresh() -> void:
	$Backlight.modulate = _rest_color()
	
func flash(color: Color = Color(3.0, 2.4, 1.0)) -> void:
	# Kill the old tweens so fast typing doesn't make them fight
	if _flash_tween: _flash_tween.kill()
	if _press_tween: _press_tween.kill()

	# Backlight: snap to flash color, then ease back to original
	_flash_tween = create_tween()
	_flash_tween.tween_property($Backlight, "modulate", color, 0.04)
	_flash_tween.tween_method(func(t: float) -> void:
		var rest := _rest_color()
		if rest.a == 0.0:
			rest = Color(color, 0.0)
		$Backlight.modulate = color.lerp(rest, t),
		0.0, 1.0, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

	# Key press: squash down, spring back
	_press_tween = create_tween()
	_press_tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.04)
	_press_tween.tween_property(self, "scale", Vector2.ONE, 0.25)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


## Return the letter associated with the key as a string
func get_key() -> String:
	return data.get_key()
	

func _unhandled_input(event: InputEvent) -> void:
	if not is_unlocked: return # Don't listen to any keys we don't own yet
	if event.is_echo(): return # Ignore echoing keys
	if event is InputEventKey and event.keycode == target_key:
		if event.is_pressed():
			flash(Color.WHITE)
			if alphabetic: WordInput.type_letter(data)
			
func _on_upgrade_selected() -> void:
	%Tooltip.update_tooltip()
	refresh()
					
func _on_area_2d_mouse_entered() -> void:
	%Tooltip.show_for_keycap(self)
	
func _on_area_2d_mouse_exited() -> void:
	%Tooltip.hide()
