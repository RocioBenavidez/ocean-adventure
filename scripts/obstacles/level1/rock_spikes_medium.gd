extends StaticObstacle
@onready var damage_strategy_script := preload("res://scripts/obstacles/strategies/damage/LowDamage.gd")

func _ready():
	damage_strategy = damage_strategy_script.new()
	set_damage_strategy(damage_strategy)
