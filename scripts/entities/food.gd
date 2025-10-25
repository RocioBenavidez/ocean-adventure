class_name Food
extends Area2D

@export var speed: float = 50.0
@export var move_right: bool = false
@export var amplitude: float = 10.0
@export var frequency: float = 2.0
@export var bonus: int = 3

var _base_y: float
var _time: float = 0.0
var _base_y_set := false

func _ready():
	add_to_group("food")
	if move_right:
		scale.x = abs(scale.x)
	else:
		scale.x = -abs(scale.x)

func _process(delta):
	if not _base_y_set:
		_base_y = global_position.y
		_base_y_set = true
	
	_time += delta
	
	var direction = Vector2.RIGHT if move_right else Vector2.LEFT
	global_position.x += direction.x * speed * delta
	global_position.y = _base_y + sin(_time * frequency) * amplitude
