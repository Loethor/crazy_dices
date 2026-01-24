# dice.gd
extends RefCounted
class_name DiceStats

var number_of_faces: int
var slots: Array[DiceSlot]
var gold_value: Array[int]
var roll_cost:int = 0

# Probability per face (must sum to 1.0)
var probabilities: Array[float]

func _init(dice_type: Types.DICE_TYPE) -> void:
	match dice_type:
		Types.DICE_TYPE.D4:
			number_of_faces = 4
		Types.DICE_TYPE.D6:
			number_of_faces = 6

	slots = []
	slots.resize(number_of_faces)

	gold_value = []
	gold_value.resize(number_of_faces)

	probabilities = []
	probabilities.resize(number_of_faces)
	var base_prob: float = 1.0 / number_of_faces

	for i in range(number_of_faces):
		slots[i] = DiceSlot.new()
		gold_value[i] = i + 1
		probabilities[i] = base_prob
