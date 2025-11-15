extends Control

@onready var scores_list = $Panel/ScoreList
@onready var back_button = $Panel/BackButton

signal back_to_menu

func _ready():
	back_button.connect("pressed", Callable(self, "_on_back_pressed"))
	show_scores()

func _on_back_pressed():
	emit_signal("back_to_menu")

func show_scores():
	# Limpiar lista
	for child in scores_list.get_children():
		child.queue_free()
	
	# Traer ranking ya ordenado desde ScoreManager
	var scores: Array = ScoreManager.get_ranking()
	
	if scores.is_empty():
		var label = Label.new()
		label.text = "No hay puntajes guardados todavía."
		scores_list.add_child(label)
		return
	
	var top_10 := scores.slice(0, 10)
	
	for i in range(top_10.size()):
		var entry = top_10[i]
		var _player_name := str(entry.get("name", "Jugador"))
		var score_val := int(entry.get("score", 0))
		
		var label = Label.new()
		label.text = "%d. %s — %d puntos" % [i + 1, name, score_val]
		scores_list.add_child(label)
