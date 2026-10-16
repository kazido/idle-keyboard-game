extends Resource
class_name Upgrade

@export var display_name: String
@export_multiline var description: String		# use %s where the multiplier goes
@export var color: Color = Color.WHITE			
@export var multiplier: float = 2.0
@export var weight: float = 1.0					# for offer rarity


func get_description() -> String:
	return description % TextHelper.mult_string(multiplier)
	
func on_played(_key: KeyData, _state: Dictionary) -> void:
	pass # Overridden
