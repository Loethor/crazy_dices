class_name Debug
extends VBoxContainer

## Emitted when spawn dice button is pressed.
signal spawn_dice_pressed
## Emitted when remove dice button is pressed.
signal remove_dice_pressed

@onready var dice_label: Label = $GridContainer/DiceLabel
@onready var turn_label: Label = $GridContainer/TurnLabel

func  _ready() -> void:
	GameState.number_of_dice_changed.connect(_on_number_of_dice_changed)
	GameState.game_turn_changed.connect(_on_game_turn_changed)
	_on_game_turn_changed()

func _on_number_of_dice_changed() -> void:
	dice_label.text = "Dices: %s" % GameState.selected_dices.size()

func _on_game_turn_changed() -> void:
	turn_label.text = "Turn: %s" % GameState.game_turn

func _on_spawn_dice_button_pressed() -> void:
	spawn_dice_pressed.emit()

func _on_remove_dice_button_pressed() -> void:
	remove_dice_pressed.emit()

func _on_add_5_gold_button_pressed() -> void:
	GameState.player_gold += 5

func _on_remove_5_gold_button_pressed() -> void:
	GameState.player_gold -= 5

func _on_add_1_gold_button_pressed() -> void:
	GameState.player_gold += 1

func _on_remove_1_gold_button_pressed() -> void:
	GameState.player_gold -= 1
