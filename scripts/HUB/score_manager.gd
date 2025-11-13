extends Node

var current_score: int = 0
var high_scores: Array = []
const MAX_SCORES = 10
const SAVE_PATH = "user://ranking.json"

func add_points(points: int):
	current_score += points

func reset_score():
	current_score = 0

func save_score(player_name: String):
	load_scores()
	high_scores.append({"name": player_name, "score": current_score, "date": Time.get_datetime_string_from_system()})
	high_scores.sort_custom(func(a, b): return b["score"] - a["score"]) # Orden descendente
	high_scores = high_scores.slice(0, MAX_SCORES)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(high_scores))
	file.close()

func load_scores():
	if not FileAccess.file_exists(SAVE_PATH):
		high_scores = []
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	high_scores = JSON.parse_string(file.get_as_text())
	file.close()

func get_high_scores() -> Array:
	return high_scores
