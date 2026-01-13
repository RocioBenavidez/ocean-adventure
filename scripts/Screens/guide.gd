extends Control

signal guide_skipped  # 🔔 Señal que emitiremos al omitir la guía

func _on_button_pressed():
	print("Guía omitida por el jugador.")
	emit_signal("guide_skipped")  # 🚀 Avisamos al GameManager
