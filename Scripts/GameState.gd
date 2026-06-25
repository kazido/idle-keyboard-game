extends Node

signal day_ended(won: bool)

enum Day {MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY}

func day_to_string(day: Day) -> String:
	return Day.keys()[day].capitalize()

var score: int = 0
var required_score: int = 5
var words_remaining: int = 5
var current_day: Day = Day.MONDAY
var current_week: int = 1
var words_used_today: Array = []
var words_used_this_week: Array = []

var keycap_upgrades: Dictionary = {} # { "A": upgrade, "D": upgrade}


func _ready() -> void:
	WordManager.word_submitted.connect(_on_word_submitted)
	
		
func _on_word_submitted(buffer: Array[Keycap]):
	var word = WordManager.buffer_to_string(buffer)
	
	# Update the list of submitted words
	words_used_today.append(word)
		
	# Update the points
	var state: Dictionary = {
		points = 0,
		word = word,
	}
	for key in buffer:
		state["points"] += key.value
	
	for key in buffer:
		if key.upgrade:
			key.upgrade.on_played(key, state)
	add_score(state["points"])
	
	# Decrease our remaining word count for the day
	words_remaining -= 1
	
	# Check win conditions
	if score >= required_score:
		emit_signal("day_ended", true)
		current_day = (current_day + 1) % Day.size() as Day
		words_used_this_week.append_array(words_used_today)
	elif words_remaining <= 0:
		emit_signal("day_ended", false)

func add_score(points: int):
	score += points
	
func reset_day():
	words_used_today.clear()
	words_remaining = 5
	score = 0
	get_tree().reload_current_scene()
	
func load_next_day():
	words_used_today.clear()
	words_remaining = 5
	score = 0
	required_score = int(required_score * 1.5)
	get_tree().reload_current_scene()
	
