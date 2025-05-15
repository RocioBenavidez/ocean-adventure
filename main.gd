extends Node2D

var score = 0

func _ready():
	update_score_label()
	$MusicaFondo.play()

func increase_score():
	score += 1
	update_score_label()

func update_score_label():
	$CanvasLayer/ScoreLabel.text = "Puntos: %s" % score


func _on_perla_collected():
	increase_score()
