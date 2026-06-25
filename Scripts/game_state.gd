extends Node

signal day_completed
signal day_failed
signal day_started # Tells UI to reload elements

enum Day {MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY}

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
	BufferManager.word_submitted.connect(_on_word_submitted)
	
		
func _on_word_submitted(buffer: Array[Keycap]):
	var word = BufferManager.buffer_to_string(buffer)
		
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
	words_used_this_week.assign(words_used_today)
	words_used_today.clear()
	
	words_remaining = 5
	score = 0
	required_score = int(required_score * 1.5)
	
	# Safely progress the days and weeks
	if current_day == Day.SUNDAY:
		current_day = Day.MONDAY
		current_week += 1
	else:
		current_day = (current_day + 1) as Day
		
	day_started.emit()
	
