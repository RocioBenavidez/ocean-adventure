extends Node2D

@export var object_scene: PackedScene        # Escena a instanciar (enemigo, comida, etc.)
@export var spawn_points: Array[NodePath]    # Rutas a Position2D/Marker2D
@export var spawn_interval: float = 2.0      # Intervalo entre spawns
@export var auto_start: bool = true          # Arranca automáticamente

var spawning := false

func _ready():
	if auto_start:
		start_spawning()

func start_spawning():
	if spawn_points.is_empty() or object_scene == null:
		return
	spawning = true
	$Timer.wait_time = spawn_interval
	$Timer.start()

func stop_spawning():
	spawning = false
	$Timer.stop()

func _on_timer_timeout():
	if not spawning or not object_scene:
		return
	# Elige un punto al azar
	var point_path = spawn_points.pick_random()
	var spawn_node = get_node_or_null(point_path)
	if not spawn_node:
		push_error("Spawner: Invalid spawn point: ", point_path)
		return
	var spawn_pos = spawn_node.global_position
	# Instancia el objeto
	var obj = object_scene.instantiate()
	# 👉 Lo agregamos al nivel (no dentro del Spawner)
	get_tree().current_scene.add_child(obj)

	# 👉 Usamos global_position para que aparezca EXACTAMENTE donde debe
	obj.global_position = spawn_pos

		
	
