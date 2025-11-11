extends Node

@onready var menu_scene = preload("res://escenas/HUB/menu.tscn")
@onready var hud_scene = preload("res://escenas/HUB/HUD.tscn")
@onready var ranking_scene = preload("res://escenas/HUB/Ranking.tscn")

const SAVE_PATH := "user://ranking.json"

var current_menu: Node
var current_level: Node
var current_hud: Node
var puntos: int = 0
var jugador_nombre := ""
var current_level_index := 0

var levels := [
	preload("res://escenas/levels/Level1.tscn"),
	preload("res://escenas/levels/Level2.tscn"),
	preload("res://escenas/levels/Level3.tscn")
]

func _ready():
	show_menu()

func show_menu():
	if current_menu:
		current_menu.queue_free()

	current_menu = menu_scene.instantiate()
	add_child(current_menu)

	current_menu.connect("start_game", Callable(self, "_on_start_game"))
	current_menu.connect("open_ranking", Callable(self, "_on_open_ranking"))

func _on_start_game(nombre: String):
	jugador_nombre = nombre
	puntos = 0
	start_level(0)

func start_level(index: int):
	if current_level:
		current_level.queue_free()
	if current_hud:
		current_hud.queue_free()
	if current_menu:
		current_menu.queue_free()

	current_level_index = index
	current_level = levels[index].instantiate()
	add_child(current_level)

	current_hud = hud_scene.instantiate()
	add_child(current_hud)

	var player = current_level.get_node_or_null("Player")
	if player:
		player.connect("player_died", Callable(self, "on_player_died"))
		player.connect("comer_comida", Callable(self, "_on_player_comer_comida"))

	current_hud.connect("time_over", Callable(self, "on_time_over"))
	current_hud.update_score(puntos) # función que deberás crear en el HUD

func _on_player_comer_comida(tiempo_extra: int):
	puntos += 10
	if current_hud:
		current_hud.update_score(puntos)
	print("Puntos:", puntos)

func save_score(score: int):
	var scores = load_scores()

	var entry = {
		"name": jugador_nombre,
		"score": score,
		"date": Time.get_datetime_string_from_system()
	}

	scores.append(entry)
	scores.sort_custom(func(a, b): return b["score"] < a["score"])

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(scores, "\t"))
	file.close()

	print("Puntuación guardada:", entry)
	
func load_scores() -> Array:
	if not FileAccess.file_exists(SAVE_PATH): 
		return [] 
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ) 
	var data = file.get_as_text() 
	file.close() 
	var result = JSON.parse_string(data)
	if typeof(result) == TYPE_ARRAY:
		return result 
	else: 
		return []
