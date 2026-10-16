class_name KeyData extends RefCounted


signal upgrade_changed
signal value_changed

var keycode: Key
var value: int = 1
var upgrade: Upgrade = null : set = set_upgrade

func _init(p_keycode: Key, p_value: int = 1) -> void:
    keycode = p_keycode
    value = p_value

func get_key() -> String:
    return OS.get_keycode_string(keycode)

func set_upgrade(new_upgrade: Upgrade) -> void:
    upgrade = new_upgrade
    upgrade_changed.emit()

func set_value(new_value: int) -> void:
    value = new_value
    value_changed.emit()
