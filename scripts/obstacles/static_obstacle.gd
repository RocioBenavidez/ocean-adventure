class_name StaticObstacle
extends Node2D

var damage_strategy: DamageStrategy = null  # Strategy por defecto

func set_damage_strategy(strategy: DamageStrategy) -> void:
	damage_strategy = strategy

func get_obstacle_info() -> Dictionary:
	var dmg = 0
	if damage_strategy:
		dmg = damage_strategy.get_damage()
	return {
		"damage": dmg
	}
