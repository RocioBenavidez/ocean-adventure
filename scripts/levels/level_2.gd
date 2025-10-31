extends Node2D

@export var siguiente_nivel: PackedScene
@export var player_prefab = preload("res://escenas/entities/player.tscn")

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
	print("Jugador instanciado con vida:", player.vida)


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		# Guardar la vida actual del jugador
		Global.vida_player = body.vida  # suponiendo que el player tiene variable "vida"
		
		if siguiente_nivel:
			print("Cambiando al siguiente nivel...")
			call_deferred("_cambiar_nivel")
		else:
			push_warning("No se ha asignado un siguiente nivel.")

func _cambiar_nivel():
	get_tree().change_scene_to_packed(siguiente_nivel)
