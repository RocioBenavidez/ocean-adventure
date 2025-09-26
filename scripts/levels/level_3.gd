extends Node2D

@export var siguiente_nivel: PackedScene
@export var player_prefab = preload("res://escenas/entities/player.tscn")

func _ready():
	spawn_player()
	

func spawn_player():
	var player = player_prefab.instantiate()
	
	# Buscar el spawn point
	var spawn_point = get_node("SpawnPoint")
	if spawn_point:
		player.position = spawn_point.position
	else:
		player.position = Vector2(100, 300)  # fallback
	
	add_child(player)
	print(" Jugador instanciado y colocado en el nivel")
