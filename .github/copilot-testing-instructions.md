# Testing Instructions (GUT Framework)

This project uses [GUT (Godot Unit Test)](https://github.com/bitwes/Gut) for automated testing.

## Test File Organization

**REQUIRED:**
- Test files MUST be in `test/` directory
- Test files MUST be named `test_<class_name>.gd`
- Test classes MUST extend `GutTest`

```
project/
├── dice/
│   └── dice.gd
└── test/
    ├── unit/
    │   └── test_dice.gd
    └── integration/
        └── test_game_flow.gd
```

## Test Naming Conventions

**Test Methods:**
- MUST start with `test_`
- MUST describe what is being tested
- SHOULD follow pattern: `test_<method>_<scenario>_<expected_result>`

**Example (Correct):**
```gdscript
func test_roll_returns_value_within_range():
func test_select_dice_adds_to_selected_array():
func test_process_roll_deducts_gold_when_affordable():
func test_spawn_dice_fails_when_max_reached():
```

**Example (Incorrect):**
```gdscript
func test1():  # ✗ not descriptive
func roll_test():  # ✗ doesn't start with test_
func test_roll():  # ✗ too vague
```

## Test Structure

**REQUIRED:** Use Arrange-Act-Assert pattern with comments

```gdscript
extends GutTest

func test_select_dice_increases_roll_cost():
    # Arrange
    var dice = Dice.new()
    dice.dice_stats = DiceStats.new(Types.DICE_TYPE.D6)
    GameState.reset_game()
    
    # Act
    GameState.select_dice(dice)
    
    # Assert
    assert_gt(GameState.roll_cost, 0, "Roll cost should increase")
```

## GUT Assertions

**Prefer specific assertions over generic ones:**

```gdscript
# Good (specific)
assert_eq(result, 5)
assert_true(dice.is_dice_selected)
assert_gt(gold, 0)
assert_has(array, item)

# Avoid (too generic)
assert(result == 5)  # ✗ less clear error messages
```

## Setup and Teardown

**Use GUT lifecycle methods:**

```gdscript
extends GutTest

var dice: Dice
var game_state: Node

func before_each():
    # Runs before each test
    GameState.reset_game()
    dice = Dice.new()

func after_each():
    # Runs after each test
    if dice:
        dice.free()

func before_all():
    # Runs once before all tests in this file
    pass

func after_all():
    # Runs once after all tests in this file
    pass
```

## Mocking and Doubles

**When to use doubles:**
- ✓ Use when testing requires external dependencies
- ✓ Use to isolate unit under test
- ✓ Document why mock is needed

```gdscript
func test_dice_roll_emits_signal():
    # Arrange
    var dice = Dice.new()
    var signal_watcher = watch_signals(dice)
    
    # Act
    dice.roll()
    
    # Assert
    assert_signal_emitted(dice, "number_rolled")
```

## Test Coverage Goals

- Core game logic (GameState): 100%
- Game entities (Dice, DiceStats): 90%+
- UI controllers: 70%+
- Scenes/integration: Basic happy path coverage

## Running Tests

```bash
# Run all tests
godot --headless -s addons/gut/gut_cmdln.gd

# Run specific test file
godot --headless -s addons/gut/gut_cmdln.gd -gtest=test/unit/test_dice.gd

# Run with GUI
# Project > Tools > Run GUT
```

## Common Patterns

**Testing signals:**
```gdscript
func test_gold_changed_signal_emitted():
    var signal_watcher = watch_signals(GameState)
    GameState.player_gold = 10
    assert_signal_emitted(GameState, "gold_changed")
```

**Testing state changes:**
```gdscript
func test_process_roll_advances_turn():
    var initial_turn = GameState.game_turn
    GameState.process_roll()
    assert_eq(GameState.game_turn, initial_turn + 1)
```

**Testing arrays:**
```gdscript
func test_selected_dices_contains_selected_dice():
    var dice = Dice.new()
    GameState.select_dice(dice)
    assert_has(GameState.selected_dices, dice)
```

## What NOT to Test

- ✗ Godot engine functionality (node hierarchy, signals work)
- ✗ Simple getters/setters without logic
- ✗ Private methods (test through public interface)
- ✗ UI layout/positioning (unless critical to gameplay)

## Documentation in Tests

**Test methods do NOT need doc comments.** The method name should be self-documenting.

**DO add comments for:**
- Complex test setup
- Non-obvious assertions
- Why certain values are used

```gdscript
func test_roll_cost_calculation_with_multiple_dice():
    # Cost formula: (num_dice - 1) + extra_costs
    # With 3 dice and no extra costs: (3 - 1) + 0 = 2
    GameState.select_dice(dice1)
    GameState.select_dice(dice2)
    GameState.select_dice(dice3)
    
    assert_eq(GameState.roll_cost, 2)
```