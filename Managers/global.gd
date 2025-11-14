extends Node

var vida_player: int = 100  # vida inicial
var score: int = 0

signal  update_s

func reset():
	vida_player = 100
	score = 0

func sum_score():
	score += 50
	ScoreManager.add_points(50)
	emit_signal("update_s",score)

func rest_score():
	score -= 10
	ScoreManager.add_points(-10)
	emit_signal("update_s",score)
