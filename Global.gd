extends Node

signal money_changed(new_amount)
signal key_unlocked(key_code)

var money: int = 0:
	set(value):
		money = value
		money_changed.emit(money)
		
		
var key_registry: Dictionary = {}
var unlock_order: Array[Key] = [
	# --- PHASE 1: THE HOME ROW (The "Resting" Position) ---
	KEY_H,          	# Start at the center (Index fingers)
	KEY_F, KEY_J,          # Move slightly out (Index fingers)
	KEY_D, KEY_K,          # Middle fingers
	KEY_S, KEY_L,          # Ring fingers
	KEY_A, KEY_SEMICOLON,  # Pinkies
	
	# --- PHASE 2: THE TOP ROW (The "Reach Up" Position) ---
	KEY_T, KEY_Y,          # Index reach up
	KEY_R, KEY_U,          # Index standard up
	KEY_E, KEY_I,          # Middle up
	KEY_W, KEY_O,          # Ring up
	KEY_Q, KEY_P,          # Pinky up
	
	# --- PHASE 3: THE BOTTOM ROW (The "Reach Down" Position) ---
	KEY_V, KEY_B, KEY_N, KEY_M, # Index reach down
	KEY_C, KEY_COMMA,           # Middle down
	KEY_X, KEY_PERIOD,          # Ring down
	KEY_Z, KEY_SLASH,           # Pinky down
	
	# --- PHASE 4: UTILITY & SYSTEM ---
	KEY_SPACE,
	KEY_ENTER,
	KEY_BACKSPACE,
	KEY_SHIFT,
	KEY_TAB
]
var next_key_cost: int = 10

func register_key(code: Key, instance: Node2D):
	key_registry[code] = instance

func buy_key():
	if money >= next_key_cost and unlock_order.size() > 0:
		money -= next_key_cost
		var new_key = unlock_order.pop_front()
		
		if key_registry.has(new_key):
			_animate_unlock(key_registry[new_key])
			
		next_key_cost *= 2 # Change this to change the scaling
		
func _animate_unlock(key_node: Node2D):
	key_node.is_unlocked = true
	key_node.scale = Vector2.ZERO

	var tween = create_tween()
	tween.tween_property(key_node, "scale", Vector2.ONE, 0.5)\
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		
	tween.parallel().tween_property(key_node, "modulate:a", 1.0, 0.5)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
	if event.is_action_pressed("toggle_fullscreen"):
		var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_FULLSCREEN if not is_fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
