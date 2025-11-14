# Main.gd
extends Node

@onready var game_manager_scene = preload("res://Managers/GameManager.tscn")

var game_manager: Node

func _ready() -> void:
	print("🟢 Main cargó correctamente")

	# Instanciar GameManager
	game_manager = game_manager_scene.instantiate()
	add_child(game_manager)

	# Conexión entre managers (ScoreManager es autoload)
	game_manager.connect("request_save_score", Callable(self, "_on_request_save_score"))
	game_manager.connect("request_reset_score", Callable(self, "_on_request_reset_score"))
	game_manager.connect("request_add_points", Callable(self, "_on_request_add_points"))

	# Conexión para recibir el nombre del jugador
	game_manager.connect("player_name_set", Callable(self, "_on_player_name_set"))

func _on_request_save_score() -> void:
	ScoreManager.save_score()

func _on_request_reset_score() -> void:
	ScoreManager.reset()

func _on_request_add_points(amount: int) -> void:
	ScoreManager.add_points(amount)

func _on_player_name_set(nombre: String) -> void:
	# Usar start_session para inicializar el jugador y resetear puntaje
	ScoreManager.start_session(nombre)
	print("👤 Sesión iniciada para:", nombre)
