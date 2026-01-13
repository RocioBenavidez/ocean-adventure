# Main.gd
extends Node


@onready var music = $AudioStreamPlayer
@onready var game_manager_scene = preload("res://Managers/GameManager.tscn")

var game_manager: Node

func _ready() -> void:
	# Cargar archivo de música
	music.stream = load("res://assets/sonidos/main_menu_theme.mp3")
# --- Música persistente ---
	if not music.playing:
		music.play()
		
	game_manager = game_manager_scene.instantiate()
	add_child(game_manager)

	game_manager.connect("request_save_score", Callable(self, "_on_request_save_score"))
	game_manager.connect("request_reset_score", Callable(self, "_on_request_reset_score"))
	game_manager.connect("request_add_points", Callable(self, "_on_request_add_points"))
	game_manager.connect("player_name_set", Callable(self, "_on_player_name_set"))
	

func _on_request_save_score() -> void:
	ScoreManager.save_score()

func _on_request_reset_score() -> void:
	ScoreManager.reset()

func _on_request_add_points(amount: int) -> void:
	ScoreManager.add_points(amount)

func _on_player_name_set(nombre: String) -> void:
	ScoreManager.start_session(nombre)
	
