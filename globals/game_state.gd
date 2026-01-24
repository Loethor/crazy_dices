extends Node

signal gold_changed()
signal roll_cost_changed()
signal number_of_dice_changed()

var current_position: int = 0
var roll_cost: int = 0 : set = _set_roll_cost
static var extra_cost:int = 0

func _set_roll_cost(new_roll_cost:int) -> void:
	roll_cost = new_roll_cost
	roll_cost_changed.emit()

var player_gold:int = 0 : set = _set_player_gold
func _set_player_gold(new_gold:int) -> void:
	player_gold = new_gold
	gold_changed.emit()

var selected_dices: Array[Dice] = []

func select_dice(new_dice: Dice) -> void:
	if new_dice not in selected_dices:
		new_dice.is_dice_selected = true
		selected_dices.append(new_dice)
		extra_cost += new_dice.dice_stats.roll_cost
		calculate_roll_cost()
		number_of_dice_changed.emit()

func unselect_dice(dice_to_remove: Dice) -> void:
	if dice_to_remove in selected_dices:
		dice_to_remove.is_dice_selected = false
		extra_cost -= dice_to_remove.dice_stats.roll_cost
		dice_to_remove.toggle_highlight()
		selected_dices.erase(dice_to_remove)
		calculate_roll_cost()
		number_of_dice_changed.emit()

func calculate_roll_cost() -> void:
	if selected_dices.size() > 1:
		roll_cost = selected_dices.size() - 1 + extra_cost
	else:
		roll_cost = extra_cost

func unselect_all_dices() -> void:
	for dice in selected_dices:
		dice.is_dice_selected = false
		dice.toggle_highlight()
		extra_cost -= dice.dice_stats.roll_cost
	selected_dices = []
	calculate_roll_cost()
	number_of_dice_changed.emit()

func process_roll() -> void:
	# Button only enabled if you can pay, no need to check
	player_gold -= roll_cost
	for dice in selected_dices:
		dice.roll()
	unselect_all_dices()
