extends CanvasLayer

func _ready():
	WordManager.word_buffer_changed.connect(_on_word_buffer_changed)
	GameState.words_used_today_updated.connect(_on_word_list_updated)
	GameState.score_updated.connect(_on_score_updated)
	GameState.requirement_reached.connect(_on_requirement_reached)
	GameState.day_ended.connect(_on_day_ended)
	GameState.words_remaining_updated.connect(_on_words_remaining_updated)
	
	$WordBuffer.text = ""
	$Score.text = "Score: 0"
	$RequiredScore.text = "[wave]Need: " + str(GameState.required_score) + "[/wave]"
	%WordsRemainingLabel.text = "Words Remaining: " + str(GameState.words_remaining)
	
func _on_day_ended(won: bool):
	var day_counter = $"Day Counter/Label"
	if not won:
		day_counter.text = "FAILED"
		day_counter.modulate = Color.RED
		#TODO: Game over UI?
		return
	day_counter.text = "PASSED!"
	day_counter.modulate = Color.CHARTREUSE
		
func _on_words_remaining_updated(words_remaining: int):
	%WordsRemainingLabel.text = "Words Remaining: " + str(words_remaining)
		
func _on_required_score_updated(required_score: int):
	$RequiredScore.text = "Need: " + str(required_score)
	
func _on_score_updated(score: int):
	$Score.text = "Score: " + str(score)
	
func _on_requirement_reached():
	$Score.modulate = Color.GREEN
		
func _on_word_buffer_changed(buffer: Array):
	$WordBuffer.text = WordManager.buffer_to_string(buffer)

func _on_word_list_updated(words: Array):
	var word_list = %SubmittedWords
	var label = Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.text = words[-1]
	word_list.add_child(label)
