class_name Food
extends Area2D

@export var speed: float = 50.0
@export var direction: Vector2 = Vector2.LEFT  # Asegúrate de que sea unitario si usas speed
@export var amplitude: float = 20.0
@export var frequency: float = 2.0
@export var bonus: int = 3

func _ready():
	add_to_group("food")

func _process(delta):
	global_position += direction * speed * delta
