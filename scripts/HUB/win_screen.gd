extends Control

@onready var menu_scene = preload("res://escenas/HUB/menu.tscn")


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://escenas/HUB/menu.tscn")
