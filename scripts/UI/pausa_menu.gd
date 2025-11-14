extends CanvasLayer

signal resume_pressed
signal exit_pressed

@onready var btn_reanudar := $VBoxContainer/Button_Reanudar
@onready var btn_exit := $VBoxContainer/Button_Exit

func _ready():
	hide()
	btn_reanudar.pressed.connect(_on_reanudar_pressed)
	btn_exit.pressed.connect(_on_exit_pressed)

func _on_reanudar_pressed():
	emit_signal("resume_pressed")

func _on_exit_pressed():
	emit_signal("exit_pressed")
