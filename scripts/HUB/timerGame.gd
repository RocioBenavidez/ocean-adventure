extends Node2D

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0
var puntos: int = 0

signal timer_updated(minutes, seconds, msec)

func _process(delta) -> void:
	time += delta
	msec = fmod(time, 1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	
	if int(seconds) != int(fmod(time - delta, 60)):
		puntos += 10  
		emit_signal("timer_updated", minutes, seconds, msec, puntos)
	
	$Minutes.text = "%02d:" % minutes
	$Seconds.text = "%02d:" % seconds
	$Msecs.text = "%03d:" % msec

func stop() -> void:
	set_process(false)

func get_time_formatted() -> String:
	return "%02d:%02d.%03d" % [minutes, seconds, msec]
	
