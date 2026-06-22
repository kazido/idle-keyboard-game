extends Resource
class_name Upgrade

enum UpgradeType {FLAT, MULTIPLIER}

@export var upgrade_name: String
@export var upgrade_type: UpgradeType
@export var amount: float
