extends CanvasLayer

var game_over_screen = preload("res://Scenes/Screens/GameOver.tscn")
var day_completed_screen = preload("res://Scenes/Screens/DayCompleted.tscn")

func _ready():
	WordManager.word_buffer_changed.connect(_on_word_buffer_changed)
	WordManager.word_submitted.connect(_on_word_submitted)
	GameState.day_ended.connect(_on_day_ended)
	
	init_ui()
	
## Setup the UI for the current day
func init_ui():
	$WordBuffer.text = ""
	$Score.text = "Score: " + str(GameState.score)
	$RequiredScore.text = "[wave]Need: " + str(GameState.required_score) + "[/wave]"
	%WordsRemainingLabel.text = "Words Remaining: " + str(GameState.words_remaining)
	%DayCounterLabel.text = "DAY " + str(GameState.current_day)
	
## Handles updating score, words remamining, and list of submitted words upon
## submitting a word
func _on_word_submitted(_buffer):
	$Score.text = "Score: " + str(GameState.score)
	%WordsRemainingLabel.text = "Words Remaining: " + str(GameState.words_remaining)
	
	# Add the submitted word to the list
	var label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.text = WordManager.buffer_to_string(_buffer)
	%SubmittedWords.add_child(label)
	
	# Change the color of the score if it's enough
	if GameState.score >= GameState.required_score:
		$Score.modulate = Color.GREEN
	
## Add the game over or day completed screen on day's end
func _on_day_ended(won: bool):
	var day_counter = %DayCounterLabel
	if not won:
		day_counter.text = "FAILED"
		day_counter.modulate = Color.RED
		add_child(game_over_screen.instantiate())
	else:
		day_counter.text = "PASSED!"
		day_counter.modulate = Color.CHARTREUSE
		add_child(day_completed_screen.instantiate())
	get_tree().paused = true
		
## Updates the screen whenever the word being typed changes
func _on_word_buffer_changed(buffer: Array):
	$WordBuffer.text = WordManager.buffer_to_string(buffer)
