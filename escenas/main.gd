extends Node

# Cargamos el menú principal
var menu_scene: PackedScene = preload("res://escenas/HUB/menu.tscn")
var current_scene: Node = null

func _ready():
	load_scene(menu_scene)

# Función para cargar una escena (menú, juego, etc.)
func load_scene(scene_packed: PackedScene):
	if current_scene:
		current_scene.queue_free()  # eliminar escena anterior
	current_scene = scene_packed.instantiate()
	add_child(current_scene)
	# Conectamos las señales del menú si existen
	if current_scene.has_signal("start_game"):
		current_scene.connect("start_game", Callable(self, "_on_start_game"))
	if current_scene.has_signal("open_ranking"):
		current_scene.connect("open_ranking", Callable(self, "_on_open_ranking"))
		
func _on_start_game():
	var game_scene = preload("res://escenas/HUB/GameManager.tscn")
	load_scene(game_scene)


#func _on_open_ranking():
	#var ranking_scene: PackedScene = preload("res://escenas/HUB/ranking.tscn")
	#load_scene(ranking_scene)
