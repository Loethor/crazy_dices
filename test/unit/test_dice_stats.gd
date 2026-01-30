extends GutTest

## Test DiceStats initialization for D4
func test_init_d4_sets_correct_number_of_faces() -> void:
	# Act
	var stats = DiceStats.new(Types.DICE_TYPE.D4)

	# Assert
	assert_eq(stats.number_of_faces, 4, "D4 should have 4 faces")

func test_init_d4_creates_correct_slots_array() -> void:
	# Act
	var stats = DiceStats.new(Types.DICE_TYPE.D4)

	# Assert
	assert_eq(stats.slots.size(), 4, "D4 should have 4 slots")
	for i in range(stats.slots.size()):
		assert_not_null(stats.slots[i], "Slot %s should be initialized" % i)
		assert_true(stats.slots[i] is DiceSlot, "Slot %s should be DiceSlot" % i)

func test_init_d4_creates_correct_gold_values() -> void:
	# Act
	var stats = DiceStats.new(Types.DICE_TYPE.D4)

	# Assert
	assert_eq(stats.gold_value.size(), 4, "D4 should have 4 gold values")
	assert_eq(stats.gold_value[0], 1, "First face should be worth 1 gold")
	assert_eq(stats.gold_value[1], 2, "Second face should be worth 2 gold")
	assert_eq(stats.gold_value[2], 3, "Third face should be worth 3 gold")
	assert_eq(stats.gold_value[3], 4, "Fourth face should be worth 4 gold")

func test_init_d4_creates_uniform_probabilities() -> void:
	# Act
	var stats = DiceStats.new(Types.DICE_TYPE.D4)

	# Assert
	assert_eq(stats.probabilities.size(), 4, "D4 should have 4 probabilities")
	var expected_prob = 0.25
	for i in range(stats.probabilities.size()):
		assert_almost_eq(stats.probabilities[i], expected_prob, 0.001, 
			"Probability %s should be 0.25" % i)

func test_init_d4_probabilities_sum_to_one() -> void:
	# Act
	var stats = DiceStats.new(Types.DICE_TYPE.D4)

	# Assert
	var sum = 0.0
	for prob in stats.probabilities:
		sum += prob
	assert_almost_eq(sum, 1.0, 0.001, "Probabilities should sum to 1.0")

func test_init_d4_sets_default_roll_cost() -> void:
	# Act
	var stats = DiceStats.new(Types.DICE_TYPE.D4)

	# Assert
	assert_eq(stats.roll_cost, 0, "Default roll cost should be 0")

## Test DiceStats initialization for D6
func test_init_d6_sets_correct_number_of_faces() -> void:
	# Act
	var stats = DiceStats.new(Types.DICE_TYPE.D6)

	# Assert
	assert_eq(stats.number_of_faces, 6, "D6 should have 6 faces")

func test_init_d6_creates_correct_slots_array() -> void:
	# Act
	var stats = DiceStats.new(Types.DICE_TYPE.D6)

	# Assert
	assert_eq(stats.slots.size(), 6, "D6 should have 6 slots")
	for i in range(stats.slots.size()):
		assert_not_null(stats.slots[i], "Slot %s should be initialized" % i)
		assert_true(stats.slots[i] is DiceSlot, "Slot %s should be DiceSlot" % i)

func test_init_d6_creates_correct_gold_values() -> void:
	# Act
	var stats = DiceStats.new(Types.DICE_TYPE.D6)

	# Assert
	assert_eq(stats.gold_value.size(), 6, "D6 should have 6 gold values")
	assert_eq(stats.gold_value[0], 1, "First face should be worth 1 gold")
	assert_eq(stats.gold_value[1], 2, "Second face should be worth 2 gold")
	assert_eq(stats.gold_value[2], 3, "Third face should be worth 3 gold")
	assert_eq(stats.gold_value[3], 4, "Fourth face should be worth 4 gold")
	assert_eq(stats.gold_value[4], 5, "Fifth face should be worth 5 gold")
	assert_eq(stats.gold_value[5], 6, "Sixth face should be worth 6 gold")

func test_init_d6_creates_uniform_probabilities() -> void:
	# Act
	var stats = DiceStats.new(Types.DICE_TYPE.D6)

	# Assert
	assert_eq(stats.probabilities.size(), 6, "D6 should have 6 probabilities")
	var expected_prob = 1.0 / 6.0
	for i in range(stats.probabilities.size()):
		assert_almost_eq(stats.probabilities[i], expected_prob, 0.001, 
			"Probability %s should be ~0.167" % i)

func test_init_d6_probabilities_sum_to_one() -> void:
	# Act
	var stats = DiceStats.new(Types.DICE_TYPE.D6)

	# Assert
	var sum = 0.0
	for prob in stats.probabilities:
		sum += prob
	assert_almost_eq(sum, 1.0, 0.001, "Probabilities should sum to 1.0")

func test_init_d6_sets_default_roll_cost() -> void:
	# Act
	var stats = DiceStats.new(Types.DICE_TYPE.D6)

	# Assert
	assert_eq(stats.roll_cost, 0, "Default roll cost should be 0")

## Test modifying roll cost
func test_roll_cost_can_be_modified() -> void:
	# Arrange
	var stats = DiceStats.new(Types.DICE_TYPE.D6)

	# Act
	stats.roll_cost = 5

	# Assert
	assert_eq(stats.roll_cost, 5, "Roll cost should be modifiable")
