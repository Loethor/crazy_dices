extends Node

signal player_gold_changed(new_gold:int)

var current_position: int = 0

var player_gold:int = 0 : set = _set_player_gold
func _set_player_gold(new_gold:int) -> void:
	player_gold = new_gold
	player_gold_changed.emit(player_gold)
