extends Node2D

@onready var score_label = $ScoreLabel
var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0
var puntos: int = 0

var tiempo_restaante: int = 1000

signal timer_updated(minutes, seconds, msec)

func _ready():
	set_process(true)
	
	var player = get_tree().get_root().get_node("C:/Users/Usuario/OneDrive/Documentos/GameProyect/ocean-adventure/scripts/entities/player.gd")
	if player:
		player.connect("helth_changed", self, "_on_player_health_changed")
		player.connect("energy_changed", self, "_on_player_energy_changed")

func update_score(value: int):
	score_label.text = "Puntos: %s" % value

func _process(delta) -> void:
	time += delta
	msec = fmod(time, 1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	
	if seconds == 0 and msec == 0:
		puntos += 1

	emit_signal("timer_updated", minutes, seconds, msec)

	
	$Minutes.text = "%02d:" % minutes
	$Seconds.text = "%02d:" % seconds
	$Msecs.text = "%03d:" % msec

func stop() -> void:
	set_process(false)

func get_time_formatted() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, msec]
	
