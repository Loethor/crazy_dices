class_name DiceManager
extends Node
## Manages dice lifecycle, selection, and rolling.
## Dice are spawned as children of this node.

signal roll_requested(dice_to_roll: Array[Dice])

func _ready() -> void:
	add_to_group("dice_manager")
	_connect_all_dice.call_deferred()
	GameState.number_of_dice_changed.connect(_sync_dice_states)

func _connect_all_dice() -> void:
	for dice in get_children():
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
	for dice in get_children():
		if dice is Dice:
			dice.is_dice_selected = dice in GameState.selected_dices

## Spawns a new dice as a child of this manager.
## Returns the instantiated dice instance.
func spawn_dice(dice_scene: PackedScene, at_position: Vector2) -> Dice:
	var dice: Dice = dice_scene.instantiate()
	dice.position = at_position
	add_child(dice)
	_connect_dice(dice)
	return dice

## Removes the last spawned dice from the manager.
## Returns true if successful, false if no dice to remove.
func remove_last_dice() -> bool:
	var dice_to_remove: Dice = get_child(-1) if get_child_count() > 0 else null

	if dice_to_remove == null or not dice_to_remove is Dice:
		push_error("No dice to remove")
		return false

	if dice_to_remove.is_dice_selected:
		GameState.unselect_dice(dice_to_remove)

	dice_to_remove.queue_free()
	return true

## Processes the roll request through GameState and emits roll_requested signal.
## Only emits if there are dice to roll.
func request_roll() -> void:
	var dice_to_roll = GameState.process_roll()
	if dice_to_roll.size() > 0:
		roll_requested.emit(dice_to_roll)
