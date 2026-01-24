extends Node2D

const D_6 := preload("uid://p6b6xno8tuse")
const D_4 := preload("uid://uknn3h2no3y4")

@onready var dice_positions: Node2D = $DicePositions
@onready var gold_label: Label = $CanvasLayer/GoldLabel
@onready var dices: Node2D = $Dices
@onready var debug: VBoxContainer = $CanvasLayer/Debug

var current_position: int = 0
var player_gold:int = 0

@export var is_debug_enabled:bool = true

func _ready() -> void:
	debug.visible = is_debug_enabled
	_spawn_dice()
	_update_gold_label(player_gold)


func _spawn_dice():
	if current_position < 6:
		var dice_scenes:Array[PackedScene] = [D_4,D_6]
		var random_dice = dice_scenes.pick_random()
		var dice: Dice = random_dice.instantiate()
		dice.position = get_current_position()
		dice.rolled.connect(_update_player_gold)
		dices.add_child(dice)
		current_position += 1

func _remove_dice():
	if current_position >= 1:
		current_position -= 1
		var dice_to_remove = dices.get_child(-1)
		dice_to_remove.rolled.disconnect(_update_player_gold)
		dice_to_remove.queue_free()

func get_current_position() -> Vector2:
	for dice_position in dice_positions.get_children():
		if dice_position is DicePosition:
			if current_position == dice_position.order:
				return dice_position.position
	return Vector2.ZERO

func _update_player_gold(_rolled_value:int, new_gold:int):
	player_gold += new_gold
	_update_gold_label(player_gold)

func _update_gold_label(new_gold:int) -> void:
	gold_label.text = "Gold: " + str(new_gold)

func _on_spawn_dice_button_pressed() -> void:
	_spawn_dice()

func _on_remove_dice_button_pressed() -> void:
	_remove_dice()
