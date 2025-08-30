extends "res://scripts/entities/static_obstacle.gd"

@export var speed: float = 100.0
@export var amplitude: float = 100.0
@export var frequency: float = 1.5

var base_position: Vector2
var time_passed := 0.0

func _ready():
	base_position = position

func _process(delta):
	time_passed += delta
	var offset_y = sin(time_passed * frequency) * amplitude
	position = base_position - Vector2(speed * time_passed, offset_y)
