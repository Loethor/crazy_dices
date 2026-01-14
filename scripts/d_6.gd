extends Dice
class_name D6

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer

func _ready():
	randomize()
	number_of_faces = 6
	_setup_sprite()
	roll_cooldown = 3.0
	timer.wait_time = roll_cooldown

func _setup_sprite() -> void:
	sprite_2d.hframes = number_of_faces
	sprite_2d.vframes = 1
	sprite_2d.frame = 0

func roll() -> void:
	if can_roll:
		rolled_value = randi_range(1, get_number_of_faces())
		_update_face()
		print("Rolled: ", rolled_value)
		timer.start()
		can_roll = false
		return

func _update_face() -> void:
	sprite_2d.frame = rolled_value - 1


func _on_timer_timeout() -> void:
	can_roll = true
