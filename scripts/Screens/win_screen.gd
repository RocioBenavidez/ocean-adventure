extends Control

signal back_to_menu  # 👈 definimos la señal


func _on_button_pressed():
	emit_signal("back_to_menu")
