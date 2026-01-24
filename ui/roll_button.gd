extends Button

func _ready() -> void:
	# Connect signals
	GameState.roll_cost_changed.connect(_update_button_text)
	GameState.gold_changed.connect(_check_cost)

	_update_button_text()

func _update_button_text() -> void:
	text = "Roll (%s gold)" % GameState.roll_cost
	_check_cost()

func _check_cost() -> void:
	# Can only roll if you can pay it
	disabled = (GameState.roll_cost > GameState.player_gold) or \
	# You can only roll if you selected dices
	(GameState.selected_dices.size() == 0)

func _on_pressed() -> void:

	# Button only enabled if you can pay, no need to check
	GameState.player_gold -= GameState.roll_cost
	print(GameState.selected_dices)
	for dice in GameState.selected_dices:
		dice.roll()
	GameState.unselect_all_dices()
