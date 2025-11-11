extends Control

signal start_game
signal open_ranking

@onready var name_input: LineEdit = $VBoxContainer/name_input

func _on_play_pressed():
	var nombre = name_input.text.strip_edges()
	if nombre == "":
		nombre = "Jugador"
	emit_signal("start_game", nombre)

func _on_ranking_pressed():
	emit_signal("open_ranking")
