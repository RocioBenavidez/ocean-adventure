extends CanvasLayer

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var timer: Timer = $Timer
@onready var time_bar: TextureProgressBar = $TimeBar
@onready var time_aro: TextureProgressBar = $TimeBarAro

@export var tiempo_inicial: int = 20
var tiempo_restante: int = 0

func _ready():
	tiempo_restante = tiempo_inicial

	# Configuración inicial de rangos
	time_bar.min_value = 0
	time_bar.max_value = tiempo_inicial
	time_aro.min_value = 0
	time_aro.max_value = tiempo_restante

	set_time(tiempo_restante)
	timer.start()

	await get_tree().process_frame  # 🕒 Espera 1 frame para que el player se instancie

	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		player.connect("health_changed", Callable(self, "_on_player_health_changed"))
		player.connect("comer_comida", Callable(self, "_on_player_comer_comida"))
		set_health(player.vida)
	else:
		print("⚠️ No se encontró ningún nodo en el grupo 'player'")

func set_health(value: int):
	health_bar.value = value

# 🕒 Actualiza ambas barras de tiempo
func set_time(value: int):
	value = clamp(value, 0, tiempo_inicial)
	var mitad = tiempo_inicial / 2.0

	if value > mitad:
		# Primera mitad del tiempo → usa la barra
		var valor_barra = (value - mitad) / mitad * time_bar.max_value
		time_bar.value = valor_barra
		time_aro.value = time_aro.max_value
	else:
		# Segunda mitad → usa el aro
		var valor_aro = value / mitad * time_aro.max_value
		time_bar.value = 0
		time_aro.value = valor_aro
		
func _on_player_health_changed(value: int):
	set_health(value)

func _on_player_comer_comida(tiempo_extra: int):
	tiempo_restante += tiempo_extra
	set_time(tiempo_restante)

func _on_timer_timeout():
	tiempo_restante -= 1
	set_time(tiempo_restante)
	print("Tiempo restante:", tiempo_restante)
	if tiempo_restante <= 0:
		game_over("Se te acabó el tiempo")

func game_over(reason: String):
	timer.stop()
	print(reason)
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		player.set_physics_process(false)
		player.velocity = Vector2.ZERO

	get_tree().change_scene_to_file("res://escenas/HUB/GameOverTimeScreen.tscn")
