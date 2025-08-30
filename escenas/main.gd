extends Node2D

var score = 0
var timerGame
@onready var hud = $HUD

func _ready():
	hud.update_score(score)
	$MusicaFondo.play()
	
	timerGame = preload("res://escenas/timerGame.tscn").instantiate()
	add_child(timerGame)
	timerGame.stop_timer()

func increase_score():
	score += 1
	hud.update_score(score)

func increase_score():
	score +=1
	hud.update_score(score)

func _on_perla_collected():
	increase_score()
