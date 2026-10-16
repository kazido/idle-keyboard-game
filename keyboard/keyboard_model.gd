# scripts/keyboard/keyboard_model.gd
extends Node

var _keys: Dictionary = {}  # Key -> KeyData

func get_key(keycode: Key) -> KeyData:
    if not _keys.has(keycode):
        _keys[keycode] = KeyData.new(keycode)
    return _keys[keycode]

func free_keys() -> Array[KeyData]:  # For the upgrade offer, keys with no upgrades yet
    var result: Array[KeyData] = []
    for k: KeyData in _keys.values():
        if k.upgrade == null:
            result.append(k)
    return result

func reset() -> void:  # call from GameState.reset_game()
    _keys.clear()