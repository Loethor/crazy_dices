class_name DiceEquipment
extends PanelContainer

@onready var information: HBoxContainer = %Information
@onready var gold_slots: HBoxContainer = %GoldSlots
@onready var equipment_slots: HBoxContainer = %EquipmentSlots
@onready var average_gold_gain_label: Label = %AverageGoldGainLabel
@onready var spacer: Control = %Spacer

## Toggles the visibility of the equipment panel.
func toggle_visibility() -> void:
	visible = !visible

## Creates and displays labels for each face's gold value.
func initialize_gold_labels(gold_value: Array[int]) -> void:
	for value in gold_value:
		var label = Label.new()
		label.text = str(value)
		label.custom_minimum_size = Vector2(15, 15)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		gold_slots.add_child(label)

## Calculates and displays the average gold gain per roll.
func calculate_average_gold(gold_value: Array[int]) -> void:
	var sum: int = 0
	for value in gold_value:
		sum += value
	var average: float = float(sum) / gold_value.size()
	average_gold_gain_label.text = str(average)

## Creates empty equipment slot panels for future upgrades.
func initialize_equipment_slots(number_of_slots: int) -> void:
	for i in range(number_of_slots):
		var panel = PanelContainer.new()
		panel.custom_minimum_size = Vector2(15, 15)
		equipment_slots.add_child(panel)

## Sets the stretch ratio for the spacer control.
func set_spacer_stretch_ratio(ratio: int) -> void:
	spacer.size_flags_stretch_ratio = ratio
