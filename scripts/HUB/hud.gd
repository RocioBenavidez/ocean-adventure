extends CanvasLayer

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var time_bar: TextureProgressBar = $TimeBar

@export var tiempo_inicial: int = 60

var tiempo_restante: int = 0
var timer: Timer

func _ready():
	tiempo_restante = tiempo_inicial
	time_bar.max_value = tiempo_inicial
	time_bar.value = tiempo_restante
	set_time(tiempo_restante)
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1
	timer.autostart = true
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
		
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

func set_time(value: int):
	time_bar.value = value

func _on_player_health_changed(value: int):
	set_health(value)

func _on_player_comer_comida(tiempo_extra: int):
	tiempo_restante += tiempo_extra
	set_time(tiempo_restante)

func _on_timer_timeout():
	tiempo_restante -= 1
	set_time(tiempo_restante)
	if tiempo_restante <= 0:
		game_over("Se te acabó en tiempo")
	
func _on_level_up(extra_time: int):
	tiempo_restante = tiempo_inicial + extra_time
	set_time(tiempo_restante)

func game_over(reason: String):
	print(reason)
