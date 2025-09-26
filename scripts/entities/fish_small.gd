extends "res://scripts/entities/food.gd"
@onready  var animated_sprite = $AnimatedSprite

func _ready():
	animated_sprite.play()
