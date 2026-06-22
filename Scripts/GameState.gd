extends Node

signal day_ended(won: bool)

var score: int = 0
var required_score: int = 30
var words_remaining: int = 5
var current_day: int = 1
var words_used_today: Array = []
var words_used_this_week: Array = []


func _ready() -> void:
	WordManager.word_submitted.connect(_on_word_submitted)
	
		
func _on_word_submitted(buffer: Array[Keycap]):
	var word = WordManager.buffer_to_string(buffer)
	
	# Update the list of submitted words
	words_used_today.append(word)
		
	# Update the points
	var points := 0
	var multiplier := 1.0
	for key in buffer:
		points += key.get_value()
		multiplier *= key.get_multiplier()
	add_score(int(points * multiplier))
	
	# Decrease our remaining word count for the day
	words_remaining -= 1
	
	# Check win conditions
	if score >= required_score:
		emit_signal("day_ended", true)
		current_day +=1
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
	
