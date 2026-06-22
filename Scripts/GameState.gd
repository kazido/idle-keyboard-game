extends Node

signal score_updated(score: int)
signal words_used_today_updated(words: Array)
signal required_score_updated(required_score: int)
signal words_remaining_updated(words_remaining: int)
signal requirement_reached()
signal day_ended(won: bool)

@onready var score: int = 0
@onready var required_score: int = 30
@onready var words_remaining: int = 5
@onready var current_day: int = 1
@onready var words_used_today: Array = []
@onready var words_used_this_week: Array = []


func _ready() -> void:
	WordManager.connect("word_submitted", _on_word_submitted)

func change_required_score(points: int):
	required_score = points
	emit_signal("required_score_updated", required_score)
	
	
func _on_word_submitted(buffer: Array) -> bool:
	var word = WordManager.buffer_to_string(buffer)
	
	# Update the list of submitted words
	words_used_today.append(word)
	emit_signal("words_used_today_updated", words_used_today)
		
	# Update the points
	var points := 0
	for key in buffer:
		points += key.value
	add_score(points)
	
	# Decrease our remaining word count for the day
	words_remaining -= 1
	emit_signal("words_remaining_updated", words_remaining)
	
	if score >= required_score:
		emit_signal("requirement_reached")
		end_day(true)
	elif words_remaining <= 0:
		end_day(false)
	return true

func add_score(points: int):
	score += points
	emit_signal("score_updated", score)


func end_day(won: bool):
	emit_signal("day_ended", won)
	current_day += 1
	words_used_this_week.append_array(words_used_today)
