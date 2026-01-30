extends GutTest

var dice: Dice
var dice_equipment: DiceEquipment

func before_each() -> void:
	GameState.reset_game()
	dice_equipment = autofree(DiceEquipment.new())
	dice = autofree(Dice.new())
	dice.dice_type = Types.DICE_TYPE.D6
	dice.dice_equipment = dice_equipment
	dice.dice_stats = DiceStats.new(Types.DICE_TYPE.D6)

## Test get_rolled_gold
func test_get_rolled_gold_returns_correct_value_for_face_one() -> void:
	# Act
	var gold = dice.get_rolled_gold(1)

	# Assert
	assert_eq(gold, 1, "Face 1 should return 1 gold")

func test_get_rolled_gold_returns_correct_value_for_face_six() -> void:
	# Act
	var gold = dice.get_rolled_gold(6)

	# Assert
	assert_eq(gold, 6, "Face 6 should return 6 gold")

func test_get_rolled_gold_returns_correct_value_for_middle_face() -> void:
	# Act
	var gold = dice.get_rolled_gold(3)

	# Assert
	assert_eq(gold, 3, "Face 3 should return 3 gold")

## Test D4 dice
func test_get_rolled_gold_d4_returns_correct_values() -> void:
	# Arrange
	dice.dice_type = Types.DICE_TYPE.D4
	dice.dice_stats = DiceStats.new(Types.DICE_TYPE.D4)

	# Act & Assert
	assert_eq(dice.get_rolled_gold(1), 1, "D4 face 1 should return 1 gold")
	assert_eq(dice.get_rolled_gold(4), 4, "D4 face 4 should return 4 gold")

## Test selection state
func test_dice_starts_unselected() -> void:
	# Assert
	assert_false(dice.is_dice_selected, "Dice should start unselected")

func test_setting_is_dice_selected_changes_state() -> void:
	# Act
	dice.is_dice_selected = true

	# Assert
	assert_true(dice.is_dice_selected, "Dice should be selected")

func test_unselecting_dice_changes_state() -> void:
	# Arrange
	dice.is_dice_selected = true

	# Act
	dice.is_dice_selected = false

	# Assert
	assert_false(dice.is_dice_selected, "Dice should be unselected")

## Test signal emissions
func test_roll_emits_number_rolled_signal() -> void:
	# Arrange
	watch_signals(dice)

	# Act
	dice.roll()

	# Assert
	assert_signal_emitted(dice, "number_rolled", "Should emit number_rolled signal")

func test_roll_emits_value_in_valid_range() -> void:
	# Arrange
	watch_signals(dice)

	# Act
	dice.roll()

	# Assert
	var signal_params = get_signal_parameters(dice.number_rolled)
	assert_between(signal_params[0], 1, dice.dice_stats.number_of_faces,
		"Rolled value should be between 1 and number_of_faces")

func test_selection_toggled_signal_emitted() -> void:
	# Arrange
	watch_signals(dice)
	var event = InputEventMouseButton.new()
	event.pressed = true
	event.button_index = MOUSE_BUTTON_LEFT

	# Act
	dice._on_input_event(null, event, 0)

	# Assert
	assert_signal_emitted(dice.selection_toggled, "Should emit selection_toggled signal")
	assert_signal_emitted_with_parameters(dice.selection_toggled, [dice])

func test_right_click_does_not_emit_selection_toggled() -> void:
	# Arrange
	watch_signals(dice)
	var event = InputEventMouseButton.new()
	event.pressed = true
	event.button_index = MOUSE_BUTTON_RIGHT

	# Act
	dice._on_input_event(null, event, 0)

	# Assert
	assert_signal_not_emitted(dice, "selection_toggled",
		"Right click should not emit selection_toggled")

func test_non_mouse_event_does_not_emit_signal() -> void:
	# Arrange
	watch_signals(dice)
	var event = InputEventKey.new()

	# Act
	dice._on_input_event(null, event, 0)

	# Assert
	assert_signal_not_emitted(dice, "selection_toggled",
		"Non-mouse event should not emit signal")

## Test multiple rolls produce different results (probabilistic)
func test_multiple_rolls_produce_varied_results() -> void:
	# Arrange
	var results = {}
	var num_rolls = 100

	# Act
	for i in range(num_rolls):
		watch_signals(dice)
		dice.roll()
		var params = get_signal_parameters(dice.number_rolled)
		if params.size() > 0:
			var value = params[0]
			results[value] = results.get(value, 0) + 1

	# Assert
	assert_gt(results.size(), 1, "Should produce at least 2 different values in 100 rolls")
