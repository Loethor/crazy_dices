extends Label


func _ready() -> void:
	_update_gold_label()
	GameState.gold_changed.connect(_update_gold_label)

func _update_gold_label() -> void:
	text = "Gold: %s" % GameState.player_gold


func _on_roll_button_pressed() -> void:
	pass # Replace with function body.
