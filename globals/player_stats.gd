extends Node

signal player_gold_changed()
signal roll_cost_changed()

var current_position: int = 0
var roll_cost: int = 0 : set = _set_roll_cost

func _set_roll_cost(new_roll_cost:int) -> void:
	roll_cost = new_roll_cost
	roll_cost_changed.emit()

var player_gold:int = 0 : set = _set_player_gold
func _set_player_gold(new_gold:int) -> void:
	player_gold = new_gold
	player_gold_changed.emit()

var selected_dices: Array[Dice] = []

func add_dice(new_dice: Dice) -> void:
	if new_dice not in selected_dices:
		new_dice.is_dice_selected = true
		roll_cost += new_dice.dice_stats.roll_cost
		selected_dices.append(new_dice)

func remove_dice(dice_to_remove: Dice) -> void:
	if dice_to_remove in selected_dices:
		dice_to_remove.is_dice_selected = false
		roll_cost -= dice_to_remove.dice_stats.roll_cost
		selected_dices.erase(dice_to_remove)

func unselect_all_dices() -> void:
	for dice in selected_dices:
		dice.is_dice_selected = false
