class_name GameProgress
extends ProgressBar

func _ready() -> void:
	GameState.game_turn_changed.connect(_update_game_progress)

func _update_game_progress() -> void:
	value = GameState.game_turn
