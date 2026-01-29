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
	var dice_manager = get_tree().get_first_node_in_group("dice_manager")
	if dice_manager:
		dice_manager.request_roll()
