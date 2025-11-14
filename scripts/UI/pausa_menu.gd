extends CanvasLayer

signal resume_pressed
signal restart_pressed
signal exit_pressed

@onready var btn_reanudar := $Panel/VBoxContainer/Button_Reanudar
@onready var btn_restart := $Panel/VBoxContainer/Button_Restart
@onready var btn_exit := $Panel/VBoxContainer/Button_Exit

func _ready():
	hide()
	btn_reanudar.pressed.connect(_on_reanudar_pressed)
	btn_restart.pressed.connect(_on_restart_pressed)
	btn_exit.pressed.connect(_on_exit_pressed)

func _on_reanudar_pressed():
	emit_signal("resume_pressed")

func _on_restart_pressed():
	emit_signal("restart_pressed")

func _on_exit_pressed():
	emit_signal("exit_pressed")
