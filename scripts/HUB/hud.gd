extends CanvasLayer
signal time_over
signal tiempo_tick 

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var timer: Timer = $Timer
@onready var time_bar: TextureProgressBar = $TimeBar
@onready var time_aro: TextureProgressBar = $TimeBarAro
@onready var score_label: Label = $ScoreLabel 

@export var tiempo_inicial: int = 20
var tiempo_restante: int = 0
var puntos: int = 0  

func _ready():
	tiempo_restante = tiempo_inicial
	time_bar.min_value = 0
	time_bar.max_value = tiempo_inicial
	time_aro.min_value = 0
	time_aro.max_value = tiempo_inicial

	set_time(tiempo_restante)
	timer.start()

	Global.connect("update_s", Callable(self, "update_score"))

	await get_tree().process_frame

	var player = null
	while player == null:
		await get_tree().process_frame
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]

	player.connect("health_changed", Callable(self, "_on_player_health_changed"))
	player.connect("comer_comida", Callable(self, "_on_player_comer_comida"))

	set_health(player.vida)


func set_health(value: int):
	health_bar.value = value

func set_time(value: int):
	value = clamp(value, 0, tiempo_inicial)
	var mitad = tiempo_inicial / 2.0

	if value > mitad:
		var valor_barra = (value - mitad) / mitad * time_bar.max_value
		time_bar.value = valor_barra
		time_aro.value = time_aro.max_value
	else:
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
	emit_signal("tiempo_tick") 
	if tiempo_restante <= 0:
		timer.stop()
		emit_signal("time_over")


func update_score(valor: int):
	puntos = valor
	score_label.text = "SCORE: %d" % puntos
