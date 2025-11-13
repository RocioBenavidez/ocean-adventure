extends Control

const SAVE_PATH := "res://ranking.json"

@onready var scores_list = $ScoreList
@onready var back_button = $BackButton

signal back_to_menu

func _ready():
	back_button.connect("pressed", Callable(self, "_on_back_pressed"))
	show_scores()

func _on_back_pressed():
	emit_signal("back_to_menu")

func show_scores():
	scores_list.queue_free_children()  # limpia la lista antes de mostrar

	var scores = load_scores()
	if scores.is_empty():
		var label = Label.new()
		label.text = "No hay puntajes guardados todavía."
		scores_list.add_child(label)
		return

	for i in range(scores.size()):
		var entry = scores[i]
		var label = Label.new()
		label.text = "%d. %s — %d puntos (%s)" % [
			i + 1,
			entry["name"],
			entry["score"],
			entry["date"]
		]
		scores_list.add_child(label)

func load_scores() -> Array:
	if not FileAccess.file_exists(SAVE_PATH):
		return []

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = file.get_as_text()
	file.close()

	var result = JSON.parse_string(data)
	if typeof(result) == TYPE_ARRAY:
		return result
	else:
		return []
