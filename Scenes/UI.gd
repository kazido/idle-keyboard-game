extends CanvasLayer

func _ready():
	Global.word_list_updated.connect(_on_word_list_updated)
	Global.word_buffer_changed.connect(_on_word_buffer_changed)
	Global.score_updated.connect(_on_score_updated)
	Global.requirement_reached.connect(_on_requirement_reached)
	
	$WordBuffer.text = ""
	$Score.text = "Score: 0"
	$RequiredScore.text = "[wave]Need: " + str(Global.required_score) + "[/wave]"
	
	
func _on_required_score_updated(required_score: int):
	$RequiredScore.text = "Need: " + str(required_score)
	
func _on_score_updated(score: int):
	$Score.text = "Score: " + str(score)
	
func _on_requirement_reached():
	$Score.modulate = Color.GREEN
		
func _on_word_buffer_changed():
	$WordBuffer.text = Global._buffer_to_string()

func _on_word_list_updated(words: Array):
	var word_list = %Words
	var label = Label.new()
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.text = words[-1]
	word_list.add_child(label)
