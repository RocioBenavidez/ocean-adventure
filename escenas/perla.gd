extends Area2D
signal collected

func _on_body_entered(body):
	if body.is_in_group("player"):
		$SFX.play()
		emit_signal("collected")
		await  get_tree().create_timer(0.3).timeout
		queue_free()  # Borra la perla
