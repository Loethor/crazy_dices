class_name Dice
extends Area2D

## Emitted when the dice is rolled, providing the rolled value.
signal number_rolled(rolled_value:int)
## Emitted when player clicks to select/unselect this dice
signal selection_toggled(dice: Dice)

## Type of the dice (D4, D6, etc.).
@export var dice_type: Types.DICE_TYPE

## Stats associated with this dice.
var dice_stats: DiceStats

## Indicates if the dice is currently selected.
@export var is_dice_selected:bool = false : set = _set_is_dice_selected

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
const HIGHLIGHT = preload("uid://dk7bpw08ca3yp")

@export var dice_equipment: DiceEquipment

func _ready():
	randomize()
	dice_stats = DiceStats.new(dice_type)
	_setup_sprite()
	dice_equipment.initialize_gold_labels(dice_stats.gold_value)
	dice_equipment.calculate_average_gold(dice_stats.gold_value)
	dice_equipment.initialize_equipment_slots(dice_stats.number_of_faces)
	dice_equipment.set_spacer_stretch_ratio(dice_stats.number_of_faces - 1)

func _set_is_dice_selected(value: bool) -> void:
	is_dice_selected = value
	if is_node_ready():
		toggle_highlight()

func _setup_sprite() -> void:
	sprite_2d.hframes = dice_stats.number_of_faces
	sprite_2d.vframes = 1
	sprite_2d.frame = 0
	var mat = ShaderMaterial.new()
	mat.shader = HIGHLIGHT
	sprite_2d.material = mat
	toggle_highlight()

func roll() -> void:
	var rolled_value = randi_range(1, dice_stats.number_of_faces)
	_update_face(rolled_value)
	print("Rolled: ", rolled_value)
	# Emit gold amount, let listener handle adding to player gold
	number_rolled.emit(rolled_value)

func get_rolled_gold(rolled_value: int) -> int:
	return dice_stats.gold_value[rolled_value - 1]

func _update_face(rolled_value:int) -> void:
	sprite_2d.frame = rolled_value - 1

func toggle_highlight():
	sprite_2d.material.set_shader_parameter("outline_width", 1 if is_dice_selected else 0)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		selection_toggled.emit(self)

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		dice_equipment.toggle_visibility()
