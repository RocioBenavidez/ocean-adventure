extends Node

const SAVE_PATH := "user://ranking.json"

var current_score: int = 0
var current_player_name: String = ""

func start_session(player_name: String):
	current_player_name = player_name
	current_score = 0

func add_points(amount: int):
	current_score += amount

func get_score() -> int:
	return current_score

func save_score():
	if current_player_name == "":
		push_warning("⚠ No se definió el nombre del jugador.")
		return
	
	var scores = load_scores()
	var entry = {
		"name": current_player_name,
		"score": current_score,
		"date": Time.get_datetime_string_from_system()
	}
	scores.append(entry)
	scores.sort_custom(func(a, b): return b["score"] < a["score"])

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(scores, "\t"))
	file.close()
	print("💾 Puntuación guardada:", entry)

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

func reset():
	current_player_name = ""
	current_score = 0
