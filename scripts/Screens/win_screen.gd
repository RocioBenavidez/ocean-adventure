extends Control

signal back_to_menu  # 👈 definimos la señal

func _on_timer_timeout():
	emit_signal("back_to_menu")
