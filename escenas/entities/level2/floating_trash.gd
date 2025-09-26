extends "res://scripts/entities/static_obstacle.gd"

@export var speed: float = 50.0
@export var amplitude: float = 30.0
@export var frequency: float = 1.0

var base_position: Vector2
var time_passed := 0.0

func _ready():
	base_position = position

func _process(delta):
	time_passed += delta
	# Oscilación horizontal
	var offset_x = sin(time_passed * frequency) * amplitude
	# Movimiento hacia abajo constante
	var offset_y = speed * time_passed
	position = base_position + Vector2(offset_x, offset_y)
