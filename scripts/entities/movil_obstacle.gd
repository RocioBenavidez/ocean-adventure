extends "res://scripts/entities/static_obstacle.gd"

@export var speed: float = 100.0
@export var amplitude: float = 20.0
@export var frequency: float = 2.0

var base_y: float
var initialized := false

func _process(delta):
	if not initialized:
		base_y = global_position.y
		initialized = true

	global_position.x -= speed * delta
	global_position.y = base_y + sin(Time.get_ticks_msec() / 1000.0 * frequency) * amplitude
