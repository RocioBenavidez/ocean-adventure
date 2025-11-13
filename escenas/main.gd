extends Node

@onready var game_manager_scene = preload("res://scripts/GameManager.tscn")
@onready var score_manager_script = preload("res://scripts/ScoreManager.gd")

var game_manager: Node
var score_manager: Node



func _ready():
	print("🟢 Main cargó correctamente")

	# Instanciar ScoreManager a partir del script (no de una escena)
	score_manager = score_manager_script.new()
	add_child(score_manager)

	# Registrar como variable global (opcional)
	# Así podés acceder con `Global.score_manager` o similar si lo usás
	ProjectSettings.set_setting("application/config/score_manager", score_manager)

	game_manager = game_manager_scene.instantiate()
	add_child(game_manager)

	# Conexión entre managers
	game_manager.connect("request_save_score", Callable(self, "_on_request_save_score"))
	game_manager.connect("request_reset_score", Callable(self, "_on_request_reset_score"))
	game_manager.connect("request_add_points", Callable(self, "_on_request_add_points"))

	# 🆕 Conexión para recibir el nombre del jugador
	game_manager.connect("player_name_set", Callable(self, "_on_player_name_set"))

func _on_request_save_score():
	score_manager.save_score()

func _on_request_reset_score():
	score_manager.reset()

func _on_request_add_points(amount: int):
	score_manager.add_points(amount)
	
func _on_player_name_set(nombre: String):
	score_manager.current_player_name = nombre
	print("👤 Nombre del jugador guardado:", nombre)
