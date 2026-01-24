extends Button

func _ready() -> void:
	_update_button_text()
	PlayerStats.roll_cost_changed.connect(_update_button_text)

func _update_button_text() -> void:
	text = "Roll (%s gold)" % PlayerStats.roll_cost
