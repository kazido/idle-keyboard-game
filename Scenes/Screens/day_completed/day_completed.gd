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
