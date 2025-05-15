extends Node2D

@export var perla_scene: PackedScene
@export var cantidad_perlas: int = 5
@export var area_min: Vector2
@export var area_max: Vector2

func _ready():
	randomize()
	for i in range(cantidad_perlas):
		spawn_perla()
		
func spawn_perla():
	var perla = perla_scene.instantiate()
	var x = randf_range(area_min.x, area_max.x)
	var y = randf_range(area_min.y, area_max.y)
	perla.position = Vector2(x, y)
	perla.connect("collected",Callable(get_parent(),"increase_score"))
	add_child(perla)
