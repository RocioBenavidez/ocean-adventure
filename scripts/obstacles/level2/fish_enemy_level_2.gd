extends MovilObstacle

@onready var damage_strategy_script := preload("res://scripts/obstacles/strategies/damage/MediumDamage.gd")

func _ready():
	damage_strategy = damage_strategy_script.new()
	set_damage_strategy(damage_strategy)
