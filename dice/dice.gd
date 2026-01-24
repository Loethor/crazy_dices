class_name Dice
extends Area2D

signal number_rolled(rolled_value:int)

@export var dice_type: Types.DICE_TYPE

var dice_stats: DiceStats
var number_of_faces: int

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready():
	randomize()
	dice_stats = DiceStats.new(dice_type)
	number_of_faces = dice_stats.number_of_faces
	_setup_sprite()

func _setup_sprite() -> void:
	sprite_2d.hframes = number_of_faces
	sprite_2d.vframes = 1
	sprite_2d.frame = 0

func roll() -> void:
	var rolled_value = randi_range(1, number_of_faces)
	_update_face(rolled_value)
	print("Rolled: ", rolled_value)
	number_rolled.emit(rolled_value)
	PlayerStats.player_gold += dice_stats.gold_value[rolled_value-1]

func _update_face(rolled_value:int ) -> void:
	sprite_2d.frame = rolled_value - 1

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		roll()
