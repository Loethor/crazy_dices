extends GutTest

var dice: Dice

func before_each() -> void:
	GameState.reset_game()
	dice = Dice.new()
	dice.dice_stats = DiceStats.new(Types.DICE_TYPE.D6)

func after_each() -> void:
	if dice:
		dice.free()

## Test basic state initialization
func test_reset_game_sets_initial_values() -> void:
	# Arrange
	GameState.game_turn = 5
	GameState.player_gold = 100

	# Act
	GameState.reset_game()

	# Assert
	assert_eq(GameState.game_turn, 1, "Turn should reset to 1")
	assert_eq(GameState.player_gold, 0, "Gold should reset to 0")
	assert_eq(GameState.roll_cost, 0, "Roll cost should reset to 0")
	assert_eq(GameState.selected_dices.size(), 0, "No dice should be selected")

## Test dice selection
func test_select_dice_adds_to_selected_array() -> void:
	# Arrange
	var initial_size = GameState.selected_dices.size()

	# Act
	GameState.select_dice(dice)

	# Assert
	assert_has(GameState.selected_dices, dice, "Dice should be in selected array")
	assert_eq(GameState.selected_dices.size(), initial_size + 1, "Array size should increase")

func test_select_dice_does_not_add_duplicate() -> void:
	# Arrange
	GameState.select_dice(dice)
	var size_after_first = GameState.selected_dices.size()

	# Act
	GameState.select_dice(dice)

	# Assert
	assert_eq(GameState.selected_dices.size(), size_after_first, "Duplicate not added")

## Test dice unselection
func test_unselect_dice_removes_from_array() -> void:
	# Arrange
	GameState.select_dice(dice)

	# Act
	GameState.unselect_dice(dice)

	# Assert
	assert_does_not_have(GameState.selected_dices, dice, "Dice should be removed")
	assert_eq(GameState.selected_dices.size(), 0, "Array should be empty")

## Test roll cost calculation
func test_calculate_roll_cost_with_one_dice() -> void:
	# Arrange
	GameState.select_dice(dice)

	# Act
	GameState.calculate_roll_cost()

	# Assert
	# Formula: max(0, size - 1) + extra_cost = max(0, 1-1) + 0 = 0
	assert_eq(GameState.roll_cost, 0, "One dice costs 0 gold")

func test_calculate_roll_cost_with_multiple_dice() -> void:
	# Arrange
	var dice2 = Dice.new()
	dice2.dice_stats = DiceStats.new(Types.DICE_TYPE.D6)
	var dice3 = Dice.new()
	dice3.dice_stats = DiceStats.new(Types.DICE_TYPE.D6)

	GameState.select_dice(dice)
	GameState.select_dice(dice2)
	GameState.select_dice(dice3)

	# Act - already calculated by select_dice

	# Assert
	# Formula: (3 - 1) + 0 = 2
	assert_eq(GameState.roll_cost, 2, "Three dice costs 2 gold")

	dice2.free()
	dice3.free()

## Test process_roll
func test_process_roll_deducts_gold() -> void:
	# Arrange
	GameState.player_gold = 10
	GameState.select_dice(dice)
	GameState.calculate_roll_cost()
	var cost = GameState.roll_cost

	# Act
	GameState.process_roll()

	# Assert
	assert_eq(GameState.player_gold, 10 - cost, "Gold should be deducted")

func test_process_roll_advances_turn() -> void:
	# Arrange
	GameState.select_dice(dice)
	var initial_turn = GameState.game_turn

	# Act
	GameState.process_roll()

	# Assert
	assert_eq(GameState.game_turn, initial_turn + 1, "Turn should advance")

func test_process_roll_clears_selected_dice() -> void:
	# Arrange
	GameState.select_dice(dice)

	# Act
	GameState.process_roll()

	# Assert
	assert_eq(GameState.selected_dices.size(), 0, "Dice should be unselected")

func test_process_roll_returns_empty_when_cannot_afford() -> void:
	# Arrange
	GameState.player_gold = 0
	GameState.select_dice(dice)
	GameState.extra_cost = 5
	GameState.calculate_roll_cost()

	# Act
	var result = GameState.process_roll()

	# Assert
	assert_eq(result.size(), 0, "Should return empty array when cannot afford")

## Test signals
func test_gold_changed_signal_emitted() -> void:
	# Arrange
	watch_signals(GameState)

	# Act
	GameState.player_gold = 10

	# Assert
	assert_signal_emitted(GameState, "gold_changed")

func test_number_of_dice_changed_signal_emitted() -> void:
	# Arrange
	watch_signals(GameState)

	# Act
	GameState.select_dice(dice)

	# Assert
	assert_signal_emitted(GameState, "number_of_dice_changed")
