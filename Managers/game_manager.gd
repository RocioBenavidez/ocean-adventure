# GameManager.gd
extends Node

signal request_save_score
signal request_reset_score
signal request_add_points(amount: int)
signal player_name_set(nombre: String)

@onready var menu_scene = preload("res://escenas/UI/menu.tscn")
@onready var pausa_menu_scene = preload("res://escenas/UI/Pausa_Menu.tscn")
@onready var guide_scene = preload("res://escenas/screens/Guide.tscn")
@onready var hud_scene = preload("res://escenas/HUB/HUD.tscn")
@onready var win_scene = preload("res://escenas/screens/WinScreen.tscn")
@onready var game_over_time = preload("res://escenas/screens/GameOverTimeScreen.tscn")
@onready var game_over = preload("res://escenas/screens/GameOverScreen.tscn")

@onready var levels = [
	preload("res://escenas/levels/Level1.tscn"),
	preload("res://escenas/levels/Level2.tscn"),
	preload("res://escenas/levels/Level3.tscn")
]

var hud_instance: Node = null
var current_scene: Node = null
var jugador_nombre := ""
var current_level_index := 0
var pausa_menu

func _ready() -> void:
	print("🎮 GameManager iniciado")

	# Cargamos el menú principal
	var menu = menu_scene.instantiate()
	_load_scene(menu)
	print("Menú cargado correctamente")

	await get_tree().process_frame
	print("Nodos hijos actuales:", get_tree().root.get_children())

	# Crear UNA SOLA instancia del menú de pausa
	pausa_menu = pausa_menu_scene.instantiate()
	add_child(pausa_menu)
	pausa_menu.hide()

	pausa_menu.resume_pressed.connect(_on_pause_resume)
	pausa_menu.exit_pressed.connect(_on_pause_exit)

func _unhandled_input(event):
	if event.is_action_pressed("pausa"):
		_toggle_pause()

# FUSIÓN DE AMBAS VERSIONES: tu comentario + la lógica de develop
func _load_scene(new_scene: Node) -> void:
	# Diferimos la carga para evitar problemas con physics/scene tree
	call_deferred("_do_load_scene", new_scene)

func _do_load_scene(new_scene: Node) -> void:
	if current_scene:
		current_scene.queue_free()
		current_scene = null

	current_scene = new_scene
	add_child(current_scene)

	if current_scene.has_signal("start_game"):
		current_scene.connect("start_game", Callable(self, "_on_start_game"))

	if current_scene.has_signal("back_to_menu"):
		current_scene.connect("back_to_menu", Callable(self, "_on_back_to_menu"))

func _on_start_game(nombre: String) -> void:
	jugador_nombre = nombre
	emit_signal("player_name_set", nombre)
	emit_signal("request_reset_score")
	_show_guide()

func _show_guide() -> void:
	var guide = guide_scene.instantiate()
	_load_scene(guide)

	if guide.has_signal("guide_skipped"):
		guide.connect("guide_skipped", Callable(self, "_on_guide_skipped"))

func _on_guide_skipped() -> void:
	print("📘 Guía omitida → iniciando nivel 1...")

	if hud_instance == null:
		hud_instance = hud_scene.instantiate()
		hud_instance.name = "HUD"
		add_child(hud_instance)
		print("HUD instanciado luego de la guía")

	_start_level(0)

func _start_level(index: int) -> void:
	emit_signal("request_add_points", 0)
	current_level_index = index

	var level = levels[index].instantiate()
	_load_scene(level)

	if hud_instance:
		if hud_instance.has_signal("time_over"):
			hud_instance.connect("time_over", Callable(self, "_on_time_over"), CONNECT_ONE_SHOT)

		if hud_instance.has_signal("tiempo_tick"):
			hud_instance.connect("tiempo_tick", Callable(self, "_on_tiempo_tick"))

	if level.has_signal("level_completed"):
		level.connect("level_completed", Callable(self, "_on_level_completed"))

func _on_level_completed() -> void:
	print("Nivel completado:", current_level_index)
	var next_index = current_level_index + 1

	if next_index < levels.size():
		print("⏭ Cargando nivel", next_index + 1)
		call_deferred("_start_level", next_index)
	else:
		print("🎉 Todos los niveles completados. Mostrando WIN")
		emit_signal("request_save_score")
		call_deferred("_load_scene", win_scene.instantiate())

func _on_pause_resume():
	get_tree().paused = false
	pausa_menu.hide()

func _on_pause_exit():
	get_tree().paused = false
	pausa_menu.hide()
	_load_scene(menu_scene.instantiate())

func _toggle_pause():
	get_tree().paused = not get_tree().paused
	if pausa_menu:
		if get_tree().paused:
			pausa_menu.show()
		else:
			pausa_menu.hide()

func _on_tiempo_tick() -> void:
	emit_signal("request_add_points", 1)

func _on_player_died() -> void:
	emit_signal("request_save_score")
	_destroy_hud()
	_load_scene(game_over.instantiate())

func _on_time_over() -> void:
	emit_signal("request_save_score")
	_destroy_hud()
	_load_scene(game_over_time.instantiate())

func _on_back_to_menu() -> void:
	_destroy_hud()
	_load_scene(menu_scene.instantiate())

func _destroy_hud() -> void:
	if hud_instance and is_instance_valid(hud_instance):
		hud_instance.queue_free()
	hud_instance = null
