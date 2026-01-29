extends Node2D

const D_6 := preload("uid://p6b6xno8tuse")
const D_4 := preload("uid://uknn3h2no3y4")
const MAX_NUMBER_OF_DICES := 6
const MIN_NUMBER_OF_DICES := 1

@onready var dice_positions: Node2D = $DicePositions
@onready var dice_manager: DiceManager = $DiceManager

@export var is_debug_enabled:bool = true
@export var debug: Debug

func _ready() -> void:
	_setup_debug()
	_spawn_dice()
	dice_manager.roll_requested.connect(_on_roll_requested)

func _setup_debug() -> void:
	debug.visible = is_debug_enabled
	if debug:
		debug.spawn_dice_pressed.connect(_on_spawn_dice_button_pressed)
		debug.remove_dice_pressed.connect(_on_remove_dice_button_pressed)


func _spawn_dice() -> void:
	if GameState.current_position >= MAX_NUMBER_OF_DICES:
		push_warning("Cannot spawn dice: maximum number reached")
		return

	var position = get_current_position()
	if position == Vector2.ZERO and GameState.current_position != 0:
		push_error("Failed to get valid dice position")
		return

	var dice_scenes: Array[PackedScene] = [D_4, D_6]
	var dice_scene = dice_scenes.pick_random()
	dice_manager.spawn_dice(dice_scene, position)
	GameState.current_position += 1

func _remove_dice() -> void:
	if GameState.current_position <= MIN_NUMBER_OF_DICES:
		push_warning("Cannot remove dice: minimum number reached")
		return

	if dice_manager.remove_last_dice():
		GameState.current_position -= 1

func get_current_position() -> Vector2:
	for dice_position in dice_positions.get_children():
		if dice_position is DicePosition:
			if GameState.current_position == dice_position.order:
				return dice_position.position

	push_warning("No DicePosition found for order: ", GameState.current_position)
	return Vector2.ZERO

func _on_roll_requested(dice_to_roll: Array[Dice]) -> void:
	for dice in dice_to_roll:
		dice.roll()

func _on_spawn_dice_button_pressed() -> void:
	_spawn_dice()

func _on_remove_dice_button_pressed() -> void:
	_remove_dice()
