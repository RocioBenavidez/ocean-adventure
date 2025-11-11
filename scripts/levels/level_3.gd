extends Node2D


@export var player_prefab = preload("res://escenas/entities/player.tscn")
signal level_completed

func _ready():
	spawn_player()
	

func spawn_player():
	var player = player_prefab.instantiate()
	
	# Colocamos al jugador
	var spawn_point = get_node("SpawnPoint")
	if spawn_point:
		player.position = spawn_point.position
	else:
		player.position = Vector2(100, 300)
	
	# Asignar la vida desde la variable global
	player.vida = Global.vida_player
	
	add_child(player)
	player.connect("player_died", Callable(get_node("/root/GameManager"), "on_player_died"))

	print("Jugador instanciado con vida:", player.vida)


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		Global.vida_player = body.vida
		print("Nivel completado.")
		emit_signal("level_completed")
