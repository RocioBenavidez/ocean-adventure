class_name StaticObstacle
extends Node2D

@export var damage: int = 10

func get_obstacle_info() -> Dictionary:
	return {
		"damage": damage
	}
