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


func _on_area_2d_body_entered(body):
	# Verificamos que el cuerpo sea el jugador
	if body.is_in_group("player") or body == get_node("Player"):  # Ajusta según cómo identifiques al jugador
		if siguiente_nivel:
			print("Cambiando al siguiente nivel...")
			get_tree().change_scene_to_packed(siguiente_nivel)
		else:
			push_warning("No se ha asignado un siguiente nivel.")
