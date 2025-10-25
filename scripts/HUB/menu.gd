extends Control
var nivel1 = preload("res://escenas/levels/Level1.tscn");

func _on_play_pressed() -> void:
	Global.reset()
	get_tree().change_scene_to_packed(nivel1);
