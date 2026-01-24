extends Label


func _ready() -> void:
	_update_gold_label(PlayerStats.player_gold)
	PlayerStats.player_gold_changed.connect(_update_gold_label)

func _update_gold_label(new_gold:int) -> void:
	text = "Gold: " + str(new_gold)
