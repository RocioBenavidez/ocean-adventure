extends Label


func _ready():
	position.y = -100  # empieza arriba, fuera de pantalla
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(position.x, 100), 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
