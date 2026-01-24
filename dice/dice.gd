class_name Dice
extends Area2D

signal number_rolled(rolled_value:int)

@export var dice_type: Types.DICE_TYPE

var dice_stats: DiceStats
@export var is_dice_selected:bool = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
const HIGHLIGHT = preload("uid://dk7bpw08ca3yp")

func _ready():
	randomize()
	dice_stats = DiceStats.new(dice_type)
	_setup_sprite()

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
	number_rolled.emit(rolled_value)
	GameState.player_gold += dice_stats.gold_value[rolled_value-1]

func _update_face(rolled_value:int ) -> void:
	sprite_2d.frame = rolled_value - 1

func toggle_highlight():
	sprite_2d.material.set_shader_parameter("outline_width", 1 if is_dice_selected else 0)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_dice_selected:
			GameState.unselect_dice(self)
		else:
			GameState.select_dice(self)
		toggle_highlight()
