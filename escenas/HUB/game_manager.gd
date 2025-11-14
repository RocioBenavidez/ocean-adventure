extends Node

signal request_save_score
signal request_reset_score
signal request_add_points(amount: int)
signal player_name_set(nombre: String)

@onready var menu_scene = preload("res://escenas/screens/menu.tscn")
@onready var guide_scene = preload("res://escenas/screens/Guide.tscn")
@onready var hud_scene = preload("res://escenas/HUB/HUD.tscn")
@onready var ranking_scene = preload("res://escenas/HUB/Ranking.tscn")
@onready var win_scene = preload("res://escenas/screens/WinScreen.tscn")

@onready var levels = [
	preload("res://escenas/levels/Level1.tscn"),
	preload("res://escenas/levels/Level2.tscn"),
	preload("res://escenas/levels/Level3.tscn")
]

var current_scene: Node
var jugador_nombre := ""
var current_level_index := 0

func _ready():
	print("🎮 GameManager iniciado")
	var menu = menu_scene.instantiate()
	_load_scene(menu)
	print("Menú cargado correctamente")

	await get_tree().process_frame
	print("Nodos hijos actuales:", get_tree().root.get_children())

func _load_scene(new_scene: Node):
	# Diferimos la carga de la nueva escena para evitar conflictos con la física
	call_deferred("_do_load_scene", new_scene)


func _do_load_scene(new_scene: Node):
	# Eliminamos la escena actual si existe
	if current_scene:
		current_scene.queue_free()

	# Cargamos la nueva escena
	current_scene = new_scene
	add_child(current_scene)

	# Conectamos señales del menú si las tiene
	if current_scene.has_signal("start_game"):
		current_scene.connect("start_game", Callable(self, "_on_start_game"))
	if current_scene.has_signal("back_to_menu"):
		current_scene.connect("back_to_menu", Callable(self, "_on_back_to_menu"))
		
func _on_start_game(nombre: String):
	jugador_nombre = nombre
	emit_signal("player_name_set", nombre)
	emit_signal("request_reset_score")
	_show_guide()

func _show_guide():
	var guide = guide_scene.instantiate()
	_load_scene(guide)
	guide.connect("guide_skipped", Callable(self, "_on_guide_skipped"))

func _on_guide_skipped():
	print("📘 Guía omitida → iniciando nivel 1...")
	_start_level(0)

func _start_level(index: int):
	emit_signal("request_add_points", 0)
	current_level_index = index

	var level = levels[index].instantiate()
	_load_scene(level)

	var hud = hud_scene.instantiate()
	add_child(hud)

	# 👇 CONECTAR EVENTO DE NIVEL COMPLETADO
	level.connect("level_completed", Callable(self, "_on_level_completed"))

	# Conexión con el jugador
	var player = level.get_node_or_null("Player")
	if player:
		player.connect("player_died", Callable(self, "_on_player_died"))


	# Conexión con HUD
	hud.connect("time_over", Callable(self, "_on_time_over"))
	hud.connect("tiempo_tick", Callable(self, "_on_tiempo_tick"))

func _on_level_completed():
	print("Nivel completado:", current_level_index)
	var next_index = current_level_index + 1

	if next_index < levels.size():
		print("⏭ Cargando nivel", next_index + 1)
		call_deferred("_start_level", next_index)  # 👈 solo esto, no lo llames directo
	else:
		print("🎉 Todos los niveles completados. Mostrando ranking...")
		emit_signal("request_save_score")
		call_deferred("_load_scene", ranking_scene.instantiate())  # 👈 solo esta línea





func _on_tiempo_tick():
	emit_signal("request_add_points", 1)

func _on_player_died():
	emit_signal("request_save_score")
	_load_scene(ranking_scene.instantiate())

func _on_time_over():
	emit_signal("request_save_score")
	_load_scene(ranking_scene.instantiate())

func _on_open_ranking():
	var ranking = ranking_scene.instantiate()
	get_tree().current_scene.add_child(ranking)


func _on_back_to_menu():
	_load_scene(menu_scene.instantiate())
