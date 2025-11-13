extends Control

@onready var menu = preload("res://escenas/screens/menu.tscn")
@onready var boton = $Button  # Path correcto al botón en la escena


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://escenas/HUB/menu.tscn")
