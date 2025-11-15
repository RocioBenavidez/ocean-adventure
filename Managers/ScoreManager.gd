extends Node

const SAVE_PATH := "user://ranking.json"

var current_score: int = 0
var current_player_name: String = ""
var ranking: Array = []  # array en memoria

func _ready():
	load_ranking()

func start_session(player_name: String):
	current_player_name = player_name
	current_score = 0

func add_points(amount: int):
	current_score += amount

func reset():
	current_score = 0

func save_score():
	if current_player_name == "":
		push_warning("⚠ No se definió el nombre del jugador.")
		return

	# asegurarnos de guardar el score como int
	var entry = {
		"name": current_player_name,
		"score": int(current_score)
	}

	ranking.append(entry)
	_sort_ranking()

	# limitar top 10 (opcional)
	if ranking.size() > 10:
		ranking = ranking.slice(0, 10)

	_save_to_file()
	print("💾 Score guardado correctamente:", entry)

func load_ranking() -> Array:
	# si no existe, creamos archivo vacío y devolvemos array vacío
	if not FileAccess.file_exists(SAVE_PATH):
		ranking = []
		_save_to_file()
		return ranking

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_warning("⚠ No se pudo abrir el archivo para lectura.")
		ranking = []
		return ranking

	var content := file.get_as_text()
	file.close()

	if content.strip_edges() == "":
		ranking = []
		return ranking

	var parsed: Variant = JSON.parse_string(content)
	
	if typeof(parsed) == TYPE_ARRAY:
		ranking = parsed
	else:
		# parsed puede ser un Dictionary con error; nos defendemos
		ranking = []
		push_warning("⚠ JSON inválido en ranking.json — reiniciando ranking.")

	# ordenar después de cargar y normalizar tipos
	_sort_ranking()
	_save_normalized_to_file_if_needed()
	return ranking

# guarda archivo (sin cambios)
func _save_to_file():
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("⚠ No se pudo abrir el archivo para escritura.")
		return
	file.store_string(JSON.stringify(ranking))
	file.close()
	print("📤 Archivo de ranking guardado.")

# Si encontramos strings en el JSON, normalizamos y reescribimos
func _save_normalized_to_file_if_needed():
	var changed := false
	for i in range(ranking.size()):
		var e = ranking[i]
		if typeof(e.get("score", 0)) == TYPE_STRING:
			e["score"] = int(e["score"])
			ranking[i] = e
			changed = true
	if changed:
		_save_to_file()

# Ordena de mayor a menor (comparator devuelve bool)
func _sort_ranking():
	# defensivo: convertir scores a int si están mal
	for i in range(ranking.size()):
		var e = ranking[i]
		if e.has("score") and typeof(e["score"]) == TYPE_STRING:
			e["score"] = int(e["score"])
			ranking[i] = e
	# sort_custom usando Callable a método que devuelve bool
	ranking.sort_custom(Callable(self, "_compare_scores"))

func _compare_scores(a, b) -> bool:
	var sa := int(a.get("score", 0))
	var sb := int(b.get("score", 0))
	return sa < sb   # true si A va antes que B


func get_ranking() -> Array:
	# devolvemos una copia (para evitar manipular ranking desde afuera)
	var rcopy = ranking.duplicate()
	# asegurar orden por si acaso
	rcopy.sort_custom(Callable(self, "_compare_scores"))
	return rcopy
