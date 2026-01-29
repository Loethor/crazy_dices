This is a game about rolling dices to earn gold and unlock new dice types.

The code uses Godot's GDScript and follows standard practices for signal emission and state management. It should be Godot 4 compatible. Gdscript 2.0 shall be used.

Don't include obvious comments.

## Code Quality

- Avoid magic numbers - use named constants when values have business meaning
- Prefer composition over inheritance
- Keep functions focused on a single responsibility
- Use early returns to reduce nesting

# Coding standards.

Internal functions and variables should be prefixed with an underscore (_).
External functions and variables should not be prefixed.

The order of members in a script should be:
01. @tool, @icon, @static_unload
02. class_name
03. extends
04. ## doc comment

05. signals
06. enums
07. constants
08. static variables
09. @export variables
10. remaining regular variables
11. @onready variables

12. _static_init()
13. remaining static methods
14. overridden built-in virtual methods:
	1. _init()
	2. _enter_tree()
	3. _ready()
	4. _process()
	5. _physics_process()
	6. remaining virtual methods
15. overridden custom methods
16. remaining methods
17. subclasses

## Signals

**REQUIRED:**
- MUST be past tense
- MUST describe the event that occurred
- MUST have named and type-hinted parameters

**Example (Correct):**
```gdscript
signal gold_changed()
signal number_rolled(rolled_value: int)
signal selection_toggled(dice: Dice)
```

**Example (Incorrect):**
```gdscript
signal gold_change()  # ✗ not past tense
signal number_rolled(int)  # ✗ parameter not named
signal roll(value)  # ✗ not past tense, not typed
```

## Type Hints

**REQUIRED (always):**
- Function parameters MUST be type hinted
- Function return types MUST be specified (use `-> void` if no return)
- Arrays MUST specify element type: `Array[Type]`

**REQUIRED (conditional):**
- Variables MUST be typed when type is not obvious from initialization

**Example (Correct):**
```gdscript
func process_roll() -> Array[Dice]:
func get_position() -> Vector2:
func spawn_dice(scene: PackedScene) -> Dice:
func _setup_debug() -> void:
var dice_stats: DiceStats
var selected_dices: Array[Dice] = []
**Constants:**
- MUST use SCREAMING_SNAKE_CASE

```gdscript
const MAX_NUMBER_OF_DICES := 6
const ROLL_ANIMATION_TIME := 1.5
```

**Getters and Setters:**
- Setter name: `_set_<property_name>`
- Setter parameter: `new_<property_name>`

```gdscript
var game_turn: int = 1 : set = _set_game_turn

func _set_game_turn(new_turn: int) -> void:
	game_turn = new_turn
	game_turn_changed.emit()
```

**@onready Variables:**
- MUST match node path in snake_case

const ROLL_ANIMATION_TIME := 1.5
```

Getters and setters should follow this pattern:
```gdscript
var game_turn: int = 1 : set = _set_game_turn

func _set_game_turn(new_turn: int) -> void:
	game_turn = new_turn
	game_turn_changed.emit()
```

@onready variable names should match their node paths in snake_case:
**Use `push_error()`:**
- For unexpected errors that indicate bugs
- When program state is invalid
- When operation cannot proceed

**Use `push_warning()`:**
- For expected edge cases
- For validation failures
- When operation can gracefully fail

**Use `assert()`:**
- For development-time validation only
- Will be removed in release builds

**Example:**
```gdscript
# push_error: bug or invalid state
if dice_to_remove == null:
	push_error("No dice to remove")
	return false

# push_warning: expected edge case
if GameState.current_position >= MAX_NUMBER_OF_DICES:
	push_warning("Cannot spawn dice: maximum reached")
	return

**REQUIRED:** All classes with `class_name` MUST have documentation.

**Format:** Brief description followed by key responsibilities.

```gdscript
class_name Dice
extends Area2D
## Represents a single dice that can be rolled to generate gold.
## Emits signals for selection and rolling events.
```

## Variable Documentation

**Documentation REQUIRED for:**
- ✓ All `@export` variables (appear in editor)
- ✓ All signals (describe when emitted)
- ✓ Regular variables when purpose is not obvious
- ✓ Constants when value needs context

**Documentation NOT required for:**
- ✗ `@onready` variables (self-explanatory from node reference)
- ✗ Local variables inside functions
- ✗ Simple loop counters

**Example:**
```gdscript
## Maximum number of turns in the game.
const MAX_TURN: int = 15

## Whether debug controls are shown.
@export var is_debug_enabled: bool = true

## Currently selected dices for rolling.
var selected_dices: Array[Dice] = []

@onready var dice_positions: Node2D = $DicePositions  # ✓ no doc needed
```

## Function Documentation

**Documentation REQUIRED for:**
- ✓ All external (public) functions
- ✓ Complex internal functions with non-obvious logic

**Documentation NOT required for:**
- ✗ Simple internal functions with clear names
- ✗ Overridden virtual methods (`_ready()`, `_process()`, etc.)
- ✗ Signal callbacks (`_on_button_pressed()`, etc.)

**Example:**
```gdscript
## Spawns a new dice as a child of this manager.
## Returns the instantiated dice instance.
func spawn_dice(dice_scene: PackedScene, at_position: Vector2) -> Dice:
	# implementation

func _connect_dice(dice: Dice) -> void:  # ✓ internal, no doc needed
	# implementation
```

## Comments

**NEVER add obvious comments.** Code should be self-documenting through clear naming.

**Bad (obvious):**
```gdscript
# Increment turn by 1
game_turn += 1
```

**Good (explains complex logic):**
```gdscripte instance.
func spawn_dice(dice_scene: PackedScene, at_position: Vector2) -> Dice:

func _connect_dice(dice: Dice) -> void:  # internal, no doc needed
```

## Comments

Don't add obvious comments. Code should be self-documenting through clear naming.

```gdscript
# Bad: obvious comment
# Increment turn by 1
game_turn += 1

# Good: complex logic explained
# Cost scales: free for 1 dice, then +1 gold per additional dice
roll_cost = max(0, selected_dices.size() - 1) + extra_cost
```