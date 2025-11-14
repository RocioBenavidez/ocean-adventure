extends CanvasLayer

signal resume_pressed
signal restart_pressed
signal exit_pressed

@onready var menu := $Panel
@onready var blur := $ColorRect

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func toggle_pause():
	var pausar = not get_tree().paused
	get_tree().paused = pausar
	
	if pausar:
		show()
	else:
		hide()

func _unhandled_input(event):
	if event.is_action_pressed("pausa"):
		toggle_pause()

func _on_reanudar_pressed():
	emit_signal("resume_pressed")
	toggle_pause()

func _on_restart_pressed():
	emit_signal("restart_pressed")

func _on_exit_pressed():
	emit_signal("exit_pressed")

func _on_button_reanudar_pressed() -> void:
	pass # Replace with function body.


func _on_button_restart_pressed() -> void:
	pass # Replace with function body.


func _on_button_exit_pressed() -> void:
	pass # Replace with function body.
