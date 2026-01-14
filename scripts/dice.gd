@abstract class_name Dice extends Area2D

@abstract func roll() -> void

var  roll_cooldown: float:
	set = set_roll_cooldown

func set_roll_cooldown(cooldown) -> void:
	roll_cooldown = cooldown

var rolled_value: int = 0:
	get = get_rolled_value

func get_rolled_value() -> int:
	return rolled_value

var number_of_faces: int = 0:
	get = get_number_of_faces

func get_number_of_faces() -> int:
	return number_of_faces

signal clicked(dice)

var can_roll: bool = true

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self)
			roll()
