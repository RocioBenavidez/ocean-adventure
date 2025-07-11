extends Area2D
class_name Food

@export var speed: float = 50.0
@export var direction: Vector2 = Vector2.LEFT
@export var nutricion: int = 10  # Energía que da al jugador

var base_position: Vector2
var time := 0.0

func _ready():
	add_to_group("food")

func _process(delta):
	position += direction * speed * delta
