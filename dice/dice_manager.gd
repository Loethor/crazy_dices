class_name DiceManager
extends Node
## Mediates between Dice instances and GameState to maintain decoupling.

signal roll_requested(dice_to_roll: Array[Dice])

@export var dices: Node2D

func _ready() -> void:
	add_to_group("dice_manager")
	_connect_all_dice.call_deferred()
	GameState.number_of_dice_changed.connect(_sync_dice_states)

func _connect_all_dice() -> void:
	var dice_nodes = dices.get_children()
	for dice in dice_nodes:
		if dice is Dice:
			_connect_dice(dice)

func _connect_dice(dice: Dice) -> void:
	if not dice.selection_toggled.is_connected(_on_dice_selection_toggled):
		dice.selection_toggled.connect(_on_dice_selection_toggled)
	if not dice.number_rolled.is_connected(_on_dice_rolled):
		dice.number_rolled.connect(_on_dice_rolled.bind(dice))

func _on_dice_selection_toggled(dice: Dice) -> void:
	if dice.is_dice_selected:
		GameState.unselect_dice(dice)
		dice.is_dice_selected = false
	else:
		GameState.select_dice(dice)
		dice.is_dice_selected = true

func _on_dice_rolled(rolled_value: int, dice: Dice) -> void:
	var gold = dice.get_rolled_gold(rolled_value)
	GameState.player_gold += gold

func _sync_dice_states() -> void:
	var all_dice = dices.get_children()
	for dice in all_dice:
		if dice is Dice:
			dice.is_dice_selected = dice in GameState.selected_dices

func connect_new_dice(dice: Dice) -> void:
	_connect_dice(dice)

func disconnect_dice(dice: Dice) -> void:
	if dice.selection_toggled.is_connected(_on_dice_selection_toggled):
		dice.selection_toggled.disconnect(_on_dice_selection_toggled)
	if dice.number_rolled.is_connected(_on_dice_rolled):
		dice.number_rolled.disconnect(_on_dice_rolled)

func request_roll() -> void:
	var dice_to_roll = GameState.process_roll()
	if dice_to_roll.size() > 0:
		roll_requested.emit(dice_to_roll)
