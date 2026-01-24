extends Button

func _ready() -> void:
	_update_button_text()
	GameState.roll_cost_changed.connect(_update_button_text)
	GameState.roll_cost_changed.connect(_check_cost)
	_check_cost()
func _update_button_text() -> void:
	text = "Roll (%s gold)" % GameState.roll_cost

func _check_cost() -> void:
	disabled = GameState.roll_cost == 0


func _on_pressed() -> void:
	pass # Replace with function body.
