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
