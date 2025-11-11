extends CanvasLayer
signal time_over

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var time_bar: ProgressBar = $TimeBar
@onready var timer: Timer = $Timer

@export var tiempo_inicial: int = 20
var tiempo_restante: int = 0

func _ready():
	tiempo_restante = tiempo_inicial
	time_bar.max_value = tiempo_inicial
	time_bar.value = tiempo_restante
	timer.start()

func set_health(value: int):
	health_bar.value = value

func set_time(value: int):
	time_bar.value = clamp(value, 0, time_bar.max_value)

func _on_player_health_changed(value: int):
	set_health(value)

func _on_player_comer_comida(tiempo_extra: int):
	tiempo_restante += tiempo_extra
	set_time(tiempo_restante)

func _on_timer_timeout():
	tiempo_restante -= 1
	set_time(tiempo_restante)
	if tiempo_restante <= 0:
		timer.stop()
		emit_signal("time_over")
