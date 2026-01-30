extends GutTest

var dice_manager: DiceManager
var d6_scene: PackedScene

func before_each() -> void:
	GameState.reset_game()
	dice_manager = autofree(DiceManager.new())
	add_child_autofree(dice_manager)
	d6_scene = load("res://dice/d_6_.tscn")

## Test spawn_dice
func test_spawn_dice_creates_dice_instance() -> void:
	# Arrange
	var initial_count = dice_manager.get_child_count()

	# Act
	var dice = dice_manager.spawn_dice(d6_scene, Vector2(100, 100))

	# Assert
	assert_not_null(dice, "Spawned dice should not be null")
	assert_true(dice is Dice, "Spawned object should be Dice type")
	assert_eq(dice_manager.get_child_count(), initial_count + 1,
		"Child count should increase by 1")

func test_spawn_dice_sets_position() -> void:
	# Arrange
	var spawn_position = Vector2(200, 150)

	# Act
	var dice = dice_manager.spawn_dice(d6_scene, spawn_position)

	# Assert
	assert_eq(dice.position, spawn_position, "Dice should be at spawn position")

func test_spawn_dice_connects_selection_signal() -> void:
	# Act
	var dice = dice_manager.spawn_dice(d6_scene, Vector2.ZERO)

	# Assert
	assert_true(dice.selection_toggled.is_connected(dice_manager._on_dice_selection_toggled),
		"selection_toggled signal should be connected")

func test_spawn_dice_connects_number_rolled_signal() -> void:
	# Act
	var dice = dice_manager.spawn_dice(d6_scene, Vector2.ZERO)

	# Assert
	assert_true(dice.number_rolled.is_connected(dice_manager._on_dice_rolled),
		"number_rolled signal should be connected")

## Test remove_last_dice
func test_remove_last_dice_removes_dice() -> void:
	# Arrange
	dice_manager.spawn_dice(d6_scene, Vector2.ZERO)
	var count_before = dice_manager.get_child_count()

	# Act
	var result = dice_manager.remove_last_dice()
	await wait_process_frames(1)

	# Assert
	assert_true(result, "Should return true on successful removal")
	assert_eq(dice_manager.get_child_count(), count_before - 1,
		"Child count should decrease")

func test_remove_last_dice_when_empty_returns_false() -> void:
	# Act
	var result = dice_manager.remove_last_dice()

	# Assert
	assert_false(result, "Should return false when no dice to remove")

func test_remove_last_dice_unselects_selected_dice() -> void:
	# Arrange
	var dice = dice_manager.spawn_dice(d6_scene, Vector2.ZERO)
	GameState.select_dice(dice)

	# Act
	dice_manager.remove_last_dice()

	# Assert
	assert_eq(GameState.selected_dices.size(), 0,
		"Selected dice should be removed from GameState")

func test_remove_last_dice_removes_correct_dice() -> void:
	# Arrange
	var dice1 = dice_manager.spawn_dice(d6_scene, Vector2.ZERO)
	var _dice2 = dice_manager.spawn_dice(d6_scene, Vector2(100, 0))
	var initial_count = dice_manager.get_child_count()

	# Act
	await wait_process_frames(1)
	dice_manager.remove_last_dice()
	await wait_process_frames(1)

	# Assert
	assert_eq(dice_manager.get_child_count(), initial_count - 1, "Child count should decrease by 1")
	assert_has(dice_manager.get_children(), dice1, "First dice should remain")

## Test _on_dice_selection_toggled
func test_on_dice_selection_toggled_selects_unselected_dice() -> void:
	# Arrange
	var dice = dice_manager.spawn_dice(d6_scene, Vector2.ZERO)
	dice.is_dice_selected = false

	# Act
	dice_manager._on_dice_selection_toggled(dice)

	# Assert
	assert_true(dice.is_dice_selected, "Dice should be selected")
	assert_has(GameState.selected_dices, dice, "Dice should be in GameState")

func test_on_dice_selection_toggled_unselects_selected_dice() -> void:
	# Arrange
	var dice = dice_manager.spawn_dice(d6_scene, Vector2.ZERO)
	dice.is_dice_selected = true
	GameState.select_dice(dice)

	# Act
	dice_manager._on_dice_selection_toggled(dice)

	# Assert
	assert_false(dice.is_dice_selected, "Dice should be unselected")
	assert_does_not_have(GameState.selected_dices, dice,
		"Dice should not be in GameState")

## Test request_roll
func test_request_roll_emits_signal_with_selected_dice() -> void:
	# Arrange
	var dice = dice_manager.spawn_dice(d6_scene, Vector2.ZERO)
	GameState.select_dice(dice)
	watch_signals(dice_manager)

	# Act
	dice_manager.request_roll()

	# Assert
	assert_signal_emitted(dice_manager, "roll_requested",
		"Should emit roll_requested signal")

func test_request_roll_does_not_emit_when_cannot_afford() -> void:
	# Arrange
	var dice = dice_manager.spawn_dice(d6_scene, Vector2.ZERO)
	GameState.select_dice(dice)
	GameState.player_gold = 0
	GameState.extra_cost = 10
	GameState.calculate_roll_cost()
	watch_signals(dice_manager)

	# Act
	dice_manager.request_roll()

	# Assert
	assert_signal_not_emitted(dice_manager, "roll_requested",
		"Should not emit when player cannot afford")

func test_request_roll_does_not_emit_when_no_dice_selected() -> void:
	# Arrange
	dice_manager.spawn_dice(d6_scene, Vector2.ZERO)
	watch_signals(dice_manager)

	# Act
	dice_manager.request_roll()

	# Assert
	assert_signal_not_emitted(dice_manager, "roll_requested",
		"Should not emit when no dice selected")

## Test _on_dice_rolled
func test_on_dice_rolled_adds_gold_to_player() -> void:
	# Arrange
	var dice = dice_manager.spawn_dice(d6_scene, Vector2.ZERO)
	await wait_process_frames(1)
	GameState.player_gold = 10
	var rolled_value = 3

	# Act
	dice_manager._on_dice_rolled(rolled_value, dice)

	# Assert
	var expected_gold = 10 + dice.get_rolled_gold(rolled_value)
	assert_eq(GameState.player_gold, expected_gold,
		"Player gold should increase by rolled value")

## Test _sync_dice_states
func test_sync_dice_states_updates_dice_selection() -> void:
	# Arrange
	var dice1 = dice_manager.spawn_dice(d6_scene, Vector2.ZERO)
	var dice2 = dice_manager.spawn_dice(d6_scene, Vector2(100, 0))
	GameState.select_dice(dice1)

	# Act
	dice_manager._sync_dice_states()

	# Assert
	assert_true(dice1.is_dice_selected, "Selected dice should be marked selected")
	assert_false(dice2.is_dice_selected, "Unselected dice should remain unselected")

func test_sync_dice_states_deselects_removed_dice() -> void:
	# Arrange
	var dice1 = dice_manager.spawn_dice(d6_scene, Vector2.ZERO)
	var dice2 = dice_manager.spawn_dice(d6_scene, Vector2(100, 0))
	GameState.select_dice(dice1)
	GameState.select_dice(dice2)
	dice1.is_dice_selected = true
	dice2.is_dice_selected = true
	GameState.unselect_dice(dice1)

	# Act
	dice_manager._sync_dice_states()

	# Assert
	assert_false(dice1.is_dice_selected, "Dice removed from GameState should be unselected")
	assert_true(dice2.is_dice_selected, "Other dice should remain selected")
