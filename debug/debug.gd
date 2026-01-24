class_name Debug
extends VBoxContainer

signal spawn_dice_pressed
signal remove_dice_pressed


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
