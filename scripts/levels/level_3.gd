extends Node2D

@export var siguiente_nivel: PackedScene
@export var player_prefab = preload("res://escenas/entities/player.tscn")
var finish = preload("res://escenas/HUB/WinScreen.tscn");
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
		call_deferred("_cambiar_nivel")

func _cambiar_nivel():
	get_tree().change_scene_to_packed(finish)
