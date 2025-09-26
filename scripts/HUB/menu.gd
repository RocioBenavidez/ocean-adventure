extends Control
var nivel1 = preload("res://escenas/levels/Level1.tscn");

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(nivel1);


func _on_load_pressed() -> void:
	pass # Replace with function body.
