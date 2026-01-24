extends Node2D

const D_6 := preload("uid://p6b6xno8tuse")
const D_4 := preload("uid://uknn3h2no3y4")
const MAX_NUMBER_OF_DICES := 6
const MIN_NUMBER_OF_DICES := 1

@onready var dice_positions: Node2D = $DicePositions
@onready var dices: Node2D = $Dices

@export var is_debug_enabled:bool = true
@export var debug: Debug

func _ready() -> void:
	_setup_debug()
	_spawn_dice()

func _setup_debug() -> void:
	debug.visible = is_debug_enabled
	if debug:
		debug.spawn_dice_pressed.connect(_on_spawn_dice_button_pressed)
		debug.remove_dice_pressed.connect(_on_remove_dice_button_pressed)


func _spawn_dice():
	if GameState.current_position < MAX_NUMBER_OF_DICES:
		var dice_scenes:Array[PackedScene] = [D_4,D_6]
		var random_dice = dice_scenes.pick_random()
		var dice: Dice = random_dice.instantiate()
		dice.position = get_current_position()
		dices.add_child(dice)
		GameState.current_position += 1

func _remove_dice():
	if GameState.current_position >= MIN_NUMBER_OF_DICES:
		GameState.current_position -= 1
		var dice_to_remove:Dice = dices.get_child(-1)
		if dice_to_remove.is_dice_selected:
			GameState.unselect_dice(dice_to_remove)
		dice_to_remove.queue_free()

func get_current_position() -> Vector2:
	for dice_position in dice_positions.get_children():
		if dice_position is DicePosition:
			if GameState.current_position == dice_position.order:
				return dice_position.position
	return Vector2.ZERO

func _on_spawn_dice_button_pressed() -> void:
	_spawn_dice()

func _on_remove_dice_button_pressed() -> void:
	_remove_dice()
