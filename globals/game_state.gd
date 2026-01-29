extends Node

## Emitted when the gold value changes.
signal gold_changed()
## Emitted when the roll cost changes.
signal roll_cost_changed()
## Emitted when the number of selected dice changes.
signal number_of_dice_changed()
## Emitted when the game turn changes.
signal game_turn_changed()


## Maximum number of turns in the game.
const MAX_TURN:int = 15
## The turn number when the shop phase occurs.
const SHOP_TURN:int = 4
## The turn number when a check phase occurs.
const CHECK_TURN:int = 5

## Current game turn.
var game_turn:int = 1 : set = _set_game_turn

## Keeps track how many of the six dice positions are filled.
var current_position: int = 0

## Cost (in gold) to roll the dice(s).
## Scales with number of dices, and the type of dice.
var roll_cost: int = 0 : set = _set_roll_cost

## Player's current gold amount.
var player_gold:int = 0 : set = _set_player_gold

## Currently selected dices for rolling.
var selected_dices: Array[Dice] = []


func _set_game_turn(new_turn:int) -> void:
	game_turn = new_turn
	game_turn_changed.emit()


## Cost to be added to the roll cost due to different effects.
var extra_cost:int = 0

func _set_roll_cost(new_roll_cost:int) -> void:
	roll_cost = new_roll_cost
	roll_cost_changed.emit()

func _set_player_gold(new_gold:int) -> void:
	player_gold = new_gold
	gold_changed.emit()


func select_dice(new_dice: Dice) -> void:
	if new_dice not in selected_dices:
		selected_dices.append(new_dice)
		extra_cost += new_dice.dice_stats.roll_cost
		calculate_roll_cost()
		number_of_dice_changed.emit()

func unselect_dice(dice_to_remove: Dice) -> void:
	if dice_to_remove in selected_dices:
		extra_cost -= dice_to_remove.dice_stats.roll_cost
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
		extra_cost -= dice.dice_stats.roll_cost
	selected_dices = []
	calculate_roll_cost()
	number_of_dice_changed.emit()

func can_afford_roll() -> bool:
	return player_gold >= roll_cost

func process_roll() -> Array[Dice]:
	if !can_afford_roll():
		push_warning("Cannot afford roll!")
		return []

	player_gold -= roll_cost

	var dice_to_roll = selected_dices.duplicate()
	unselect_all_dices()
	game_turn += 1

	return dice_to_roll

func reset_game() -> void:
	game_turn = 1
	current_position = 0
	player_gold = 0
	extra_cost = 0
	selected_dices.clear()
	calculate_roll_cost()
