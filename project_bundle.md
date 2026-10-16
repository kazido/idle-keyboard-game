# Word Roguelike — code bundle


===== keyboard/keyboard.gd =====
extends Node2D
class_name Keyboard


func _ready() -> void:
	add_to_group("keyboard")
	for key_name in GameState.keycap_upgrades:
		var keycap = find_keycap_by_letter(key_name)
		if keycap:
			apply_upgrade(keycap, GameState.keycap_upgrades[key_name])
			
## Apply an upgrade to a keycap
func apply_upgrade(keycap: Keycap, upgrade: Upgrade):
	var key_name = OS.get_keycode_string(keycap.target_key)
	GameState.keycap_upgrades[key_name] = upgrade
	keycap.set_upgrade(upgrade)
	

## Increase the value of all keycaps by amount
## used only at the end of each week
func increase_all_keycap_values(amount: int) -> void:
	for keycap: Keycap in $Keycaps.get_children():
		keycap.value =+ amount


func find_keycap_by_letter(letter: String) -> Keycap:
	for keycap: Keycap in $Keycaps.get_children():
		if  keycap.get_key() == letter:
			return keycap
	return null


===== keyboard/keycaps/keycap.gd =====
extends Node2D
class_name Keycap

@export var target_key: Key
@export var name_overwrite: String = ""
@export var alphabetic: bool = true
var backlight_color: Color = Color.TRANSPARENT

@onready var label = $Label
@onready var sprite = $AnimatedSprite2D

@export var is_unlocked: bool = true
@export var upgrade: Upgrade
var value: int = 1


func _ready() -> void:
	$Label.text = name_overwrite if name_overwrite else get_key()
	if not is_unlocked: modulate.a = 0.1
		
func set_light_color(color: Color):
	$Backlight.modulate = color
	self.color = color
	
func flash(color: Color = Color.WHITE):
	var tween = create_tween()
	tween.tween_property($Backlight, "modulate", color, 0.2)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_EXPO)
	await tween.finished
	
	var tween_out = create_tween()
	tween_out.tween_property($Backlight, "modulate", backlight_color, 1)
	
## Return the letter associated with the key as a string
func get_key() -> String:
	return OS.get_keycode_string(target_key)

## Set the keycaps upgrade
func set_upgrade(new_upgrade: Upgrade):
	new_upgrade.on_applied(self)
	upgrade = new_upgrade
			

func _unhandled_input(event: InputEvent) -> void:
	if not is_unlocked: return # Don't listen to any keys we don't own yet
	if event.is_echo(): return # Ignore echoing keys
	if event is InputEventKey and event.keycode == target_key:
		if event.is_pressed():
			flash(Color.YELLOW)
			if alphabetic: WordInput.type_letter(self)
			
					
func _on_area_2d_mouse_entered() -> void:
	%Tooltip.show_for_keycap(self)
	
func _on_area_2d_mouse_exited() -> void:
	%Tooltip.hide()


===== keyboard/keycaps/keycap_tooltip.gd =====
extends Control

func _ready():
	hide()
	
	
func _update_tooltip(keycap: Keycap):
	var key_name = OS.get_keycode_string(keycap.target_key)
	var key_value = keycap.value
	%Keyname.text = key_name + " (%s)" % key_value
	if keycap.upgrade:
		var header = "[color=%s]" % keycap.upgrade.color
		%Upgrade.text = header + keycap.upgrade.name
		%Description.text = keycap.upgrade.description
	else:
		%Upgrade.text = "[color=#999]No Upgrade"
		
		
## Show the tooltip for the keycap based on the mouse position	
func show_for_keycap(keycap):
	_update_tooltip(keycap)
	show()


===== keyboard/keycaps/keydata.gd =====
class_name KeyData

int value: = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


===== keyboard/keycaps/macro.gd =====
extends Keycap

@export var macro: Script


===== keyboard/keycaps/upgrades/base_upgrade.gd =====
extends Resource
class_name Upgrade

var name: String
var description: String
var color: String

func on_applied(keycap) -> void:
	keycap.set_light_color(Color(color))
	
func on_played(_keycap, _state: Dictionary):
	pass # Overridden


===== keyboard/keycaps/upgrades/begins_in_letter.gd =====
extends Upgrade
class_name BeginsInLetter

func _init() -> void:
	color = "#38d5fc"
	name = "Begins With"
	description = "%s if word starts with this letter" % TextHelper.mult_string(1.5)


func on_played(keycap: Keycap, state: Dictionary):
	if state["word"].begins_with(keycap.get_key()):
		state["points"] *= 1.5


===== keyboard/keycaps/upgrades/bookends.gd =====
extends Upgrade
class_name Bookends

func _init() -> void:
	color = "#FFB300"
	name = "Bookends"
	description = "%s if this letter is both first and last" % TextHelper.mult_string(8)


func on_played(keycap: Keycap, state: Dictionary):
	var word: String = state["word"]
	if word.ends_with(keycap.get_key()) and word.begins_with(keycap.get_key()):
		state["points"] *= 8


===== keyboard/keycaps/upgrades/double_down.gd =====
extends Upgrade
class_name DoubleDown

func _init() -> void:
	color = "#4DA3FF"
	name = "Double Down"
	description = "%s if this letter appears exactly 2 times" % TextHelper.mult_string(2)


func on_played(keycap: Keycap, state: Dictionary):
	var word: String = state["word"]
	if word.count(keycap.get_key()) == 2:
		state["points"] *= 2


===== keyboard/keycaps/upgrades/ends_in_letter.gd =====
extends Upgrade
class_name EndsInLetter

func _init() -> void:
	color = "#389afc"
	name = "Ends With"
	description = "%s if word ends with this letter" % TextHelper.mult_string(4)


func on_played(keycap: Keycap, state: Dictionary):
	if state["word"].ends_with(OS.get_keycode_string(keycap.target_key)):
		state["points"] *= 4


===== keyboard/keycaps/upgrades/final_stand.gd =====
extends Upgrade
class_name FinalStand

func _init() -> void:
	color = "#7C4DFF"
	name = "Final Stand"
	description = "%s if this in the last word of the day" % TextHelper.mult_string(20)


func on_played(_keycap: Keycap, state: Dictionary):
	if state["words_remaining"] == 1:
		state["points"] *= 20


===== keyboard/keycaps/upgrades/solo_star.gd =====
extends Upgrade
class_name SoloStar

func _init() -> void:
	color = "#7C4DFF"
	name = "No I In Team"
	description = "%s if this letter appears exactly 1 time" % TextHelper.mult_string(5)


func on_played(keycap: Keycap, state: Dictionary):
	var word: String = state["word"]
	if word.count(keycap.get_key()) == 1:
		state["points"] *= 5


===== keyboard/keycaps/upgrades/three_count.gd =====
extends Upgrade
class_name ThreeCount

func _init() -> void:
	color = "#cf69ff"
	name = "Three Count"
	description = "%s if this letter appears exactly 3 times" % TextHelper.mult_string(3)

func on_played(keycap: Keycap, state: Dictionary):
	var word: String = state["word"]
	if word.count(keycap.get_key()) == 3:
		state["points"] *= 3


===== keyboard/keycaps/upgrades/times_two.gd =====
extends Upgrade
class_name TimesTwo

func _init() -> void:
	color = "#a0ff70"
	name = "Times Two"
	description = "%s when used in a word" % TextHelper.mult_string(2)
	# TODO: Fix the color formatting of the name

func on_played(_keycap: Keycap, state: Dictionary):
	state["points"] *= 2


===== scenes/screens/day_completed/day_completed.gd =====
extends CanvasLayer

const SCORE_ROW_SCENE = preload("res://scenes/screens/day_completed/score_row.tscn")

@onready var vbox = %VBoxContainer
@onready var score = %Score
@onready var score_number = %ScoreNumber
@onready var hr = %HorizontalRule
@onready var shader_bg = %ShaderBackground
@onready var title = %Title

var color: Color
var color2: Color

func _ready() -> void:
	# Set the shader background to be a random color
	var val := randf()
	color = Color.from_hsv(val, 0.8, 1.0)
	color2 = Color.from_hsv(val, 0.3, 1.0)
	shader_bg.material.set_shader_parameter("glow_color", color)
	title.add_theme_color_override("default_color", color)
	hr.modulate = color2
	
	
func display_completed_day() -> void:
	var score_count := 0
	
	for key in GameState.words_used_today:
		# Update the total score
		score_count += GameState.words_used_today[key]
		score_number.text = str(score_count)
		
		# Add a new row for each word and its points
		var new_row = SCORE_ROW_SCENE.instantiate()
		new_row.get_node("Word").text = key
		new_row.get_node("Points").text = str(GameState.words_used_today[key])
		
		new_row.get_node("Word").add_theme_color_override("default_color", color2)
		new_row.get_node("Points").add_theme_color_override("default_color", color2)
		vbox.add_child(new_row)
		
		# Prepare the properties for tweening
		new_row.scale = Vector2(4.0, 4.0)
		new_row.modulate.a = 0.0
		new_row.rotation_degrees = randf_range(-10.0, 10.0)
		
		# Create the Tween to slam it down
		var tween = create_tween().set_parallel(true)
		
		tween.tween_property(new_row, "modulate:a", 1.0, 0.05)
		tween.tween_property(new_row, "rotation_degrees", 0.0, 0.15)
		tween.tween_property(new_row, "scale", Vector2(1.0, 1.0), 0.15)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		
		# Play a satisfying mechanical switch sound right as it hits
		# play_sound("mechanical_click") 
		
		# Wait a fraction of a second before slamming the next word
		await get_tree().create_timer(0.5).timeout


func _on_button_pressed() -> void:
	get_tree().paused = false
	GameState.load_next_day()


===== scenes/screens/day_completed/upgrade_selection.gd =====
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


===== scenes/screens/day_completed/upgrade_selection_card.gd =====
extends ColorRect
class_name UpgradeSelectionCard

signal picked # Emitted when this upgrade is chosen

var upgrade: Upgrade
var keycap: Keycap
var keyboard: Keyboard

func setup(new_upgrade: Upgrade):
	upgrade = new_upgrade
	%UpgradePlate.color = Color(upgrade.color)
	%UpgradeName.text = "[wave][color=%s]" % new_upgrade.color + new_upgrade.name.to_upper()
	%UpgradeDescription.text = new_upgrade.description
	
	randomize()
	keyboard = get_tree().get_first_node_in_group("keyboard")
	var keycaps = keyboard.get_node("Keycaps").get_children()
	keycap = keycaps[randi() % keycaps.size()]
	# Reselect a keycap if the randomly picked one already has an upgrade
	while keycap.upgrade:
		keycap = keycaps[randi() % keycaps.size()]
	
	%Keycap.text = keycap.get_key()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			keyboard.apply_upgrade(keycap, upgrade)
			picked.emit()


===== scenes/screens/game_over.gd =====
extends CanvasLayer

func _on_button_pressed() -> void:
	get_tree().paused = false
	GameState.reset_game()


===== scripts/game_state.gd =====
extends Node

signal day_completed
signal day_failed
signal day_started

enum Day { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }

func day_to_string(day: Day) -> String:
	return Day.keys()[day].capitalize()

var score: int = 0
var required_score: int = 30
var words_remaining: int = 5
var current_day: Day = Day.MONDAY
var current_week: int = 1
var words_used_today: Dictionary = {}
var words_used_this_week: Dictionary = {}

var keycap_upgrades: Dictionary = {} # { "A": upgrade, "D": upgrade}


func _ready() -> void:
	WordInput.word_submitted.connect(_on_word_submitted)
	
		
func _on_word_submitted(buffer: Array):
	var word = WordInput.get_word_string()
		
	# Update the points
	var state: Dictionary = {
		"points" = 0,
		"word" = word,
		"words_remaining" = words_remaining,
		"words_used_today" = words_used_today,
		"words_used_this_week" = words_used_this_week,
	}
	for key in buffer:
		state["points"] += key.value
	
	for key in buffer:
		if key.upgrade:
			key.upgrade.on_played(key, state)

	words_used_today.set(word, state["points"])
	
	add_score(state["points"])
	
	# Decrease our remaining word count for the day
	words_remaining -= 1
	
	# Check win conditions
	if score >= required_score:
		day_completed.emit()
	elif words_remaining <= 0:
		day_failed.emit()

func add_score(points: int):
	score += points
	
## Reset the game back to its original state
func reset_game():
	words_used_this_week.clear()
	current_day= Day.MONDAY
	current_week = 1
	required_score = 30
	reset_day()
	
## Reset the day only
func reset_day():
	words_used_today.clear()
	words_remaining = 5
	score = 0
	
	day_started.emit()
	
## Start the next day
func load_next_day():
	# Archive the words used today
	words_used_this_week.merge(words_used_today)
	words_used_today.clear()
	
	words_remaining = 5
	score = 0
	required_score = int(required_score * 1.5)
	
	# Safely progress the days and weeks
	if current_day == Day.SUNDAY:
		current_day = Day.MONDAY
		current_week += 1
		words_used_this_week.clear()
	else:
		current_day = (current_day + 1) as Day
		
	day_started.emit()
	


===== scripts/helpers/text_helper.gd =====
extends Node


func format_number(value: float) -> String:
	if value == int(value):
		return str(int(value))
	else:
		return str(value)

func mult_string(amount: float) -> String:
	var prefix = "[color=#eb4034][wave freq=%d amp=%d][b]" % [amount, amount]
	var suffix = "[/b][/wave][/color]"
	var middle = "x%s MULT" % format_number(amount)
	return prefix + middle + suffix


===== scripts/helpers/valid_words.gd =====
extends Node

var valid_words: Dictionary = {}

func _ready():
	load_word_list()

func load_word_list():
	var file = FileAccess.open("res://scripts/helpers/words_alpha.txt", FileAccess.READ)
	if file == null:
		push_error("Could not open word list!")
		return
	while not file.eof_reached():
		var word = file.get_line().strip_edges().to_lower()
		if word != "":
			valid_words[word] = true
	file.close()

func is_valid_word(word: String) -> bool:
	return valid_words.has(word.to_lower())


===== scripts/keybinds.gd =====
extends Node
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
		
	if event.is_action_pressed("backspace", true):
		WordInput.delete_letter()
		
	if event.is_action_pressed("submit"):
		WordInput.submit_word()
	
	if event.is_action_pressed("toggle_fullscreen"):
		var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_FULLSCREEN if not is_fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)


===== scripts/letter_display.gd =====
extends Label
class_name LetterDisplay

func set_letter(keycap: Keycap, color: Color) -> void:
	text = OS.get_keycode_string(keycap.target_key)
	add_theme_font_size_override("font_size", 40)
	add_theme_color_override("font_color", color)
	
func bounce(height: float = 20.0):
	var tween = create_tween()
	tween.tween_property(self, "position:y", -height, 0.1)\
		.set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", 0, 0.1)\
		.set_trans(Tween.TRANS_BOUNCE)
		
func slam(intensity: float):
	bounce(intensity * 5)
	


===== scripts/word_display.gd =====
extends HBoxContainer
class_name WordDisplay


func _ready() -> void:
	# Listen for updates from WordManager
	WordInput.word_changed.connect(_update_buffer)
	WordInput.word_submitted.connect(_submit_buffer)

## Called whenever the word input changes
func _update_buffer(keys: Array[Keycap], state: WordInput.WordState) -> void:
	var color: Color
	
	match state:
		WordInput.WordState.INVALID:
			color = Color.DIM_GRAY
		WordInput.WordState.USED:
			color = Color.TOMATO
		WordInput.WordState.VALID:
			color = Color.GREEN_YELLOW
			
	var letters = get_children()
	
	while letters.size() < keys.size():
		var keycap: Keycap = keys[letters.size()]
		
		var label := LetterDisplay.new()
		label.set_letter(keycap, color)
		
		%WordDisplay.add_child(label)
		#label.bounce() # TODO: Fix the label slamming into place
		letters = %WordDisplay.get_children()
		
	# Remove the deleted letters
	while letters.size() > keys.size():
		letters[-1].queue_free()
		letters.pop_back()
		
	# Update the color of existing letters
	for letter in %WordDisplay.get_children():
		letter.add_theme_color_override("font_color", color)
		
## Called whenever the word is submitted
func _submit_buffer(_keys: Array[Keycap]) -> void:
	await animate_submission()
	
	WordInput.clear_buffer()
	
	
	# Add the submitted word to the list on screen
	# TODO: This is handled on the UI.
	var label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.text = WordInput.get_word_string()
	%SubmittedWords.add_child(label)
	
	%Score.text = "Score: " + str(GameState.score)
	%Bar.value = GameState.score
	%WordsRemainingLabel.text = "Words Remaining: " + str(GameState.words_remaining)

	# Change the color of the score if it's enough
	if GameState.score >= GameState.required_score:
		%Score.modulate = Color.GREEN
		

func animate_submission() -> void:
	var letters = get_children()
	var tween = create_tween()
	
	for i in letters.size():
		tween.tween_property(letters[i], "position:y", -10, 0.2)\
			.set_trans(Tween.TRANS_BOUNCE)\
			.set_ease(Tween.EASE_OUT)
	await tween.finished
	await get_tree().create_timer(0.3).timeout	


===== scripts/word_input.gd =====
## LOGICAL REPRESENTATION of our typed word. ALL backend
extends Node

signal word_changed(buffer: Array[Keycap], state: WordState)
signal word_submitted(buffer: Array[Keycap])

enum WordState { VALID, USED, INVALID }

var buffer: Array[Keycap] = []


# --- [ BUFFER EDITING METHODS ] ---
func clear_buffer() -> void:
	buffer.clear()
	word_changed.emit(buffer, get_word_state())

func type_letter(keycap) -> void:
	# Maximum word length of 24
	if buffer.size() >= 24:
		return
		
	buffer.append(keycap)
	word_changed.emit(buffer, get_word_state())

func delete_letter():
	if buffer.is_empty():
		return
		
	buffer.pop_back()
	word_changed.emit(buffer, get_word_state())
	
func submit_word() -> void:
	if get_word_state() != WordState.VALID:
		return
		
	# Give signal listeners their own copy of the submitted word
	var submitted_buffer = buffer.duplicate()
	word_submitted.emit(submitted_buffer)
		
func get_word_state() -> WordState:
	var word = get_word_string()
	
	if not ValidWords.is_valid_word(word):
		return WordState.INVALID
	if word.length() <= 2:
		return WordState.INVALID
	if GameState.words_used_today.has(word):
		return WordState.USED	
	if GameState.words_used_this_week.has(word):
		return WordState.USED
	return WordState.VALID
		
func get_word_string() -> String:
	var word = ""
	for keycap in buffer:
		word += keycap.get_key()
	return word
