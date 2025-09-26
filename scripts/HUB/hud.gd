extends CanvasLayer

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var time_bar: TextureProgressBar = $EnergyBar
@export var tiempo_inicial: int = 60
var tiempo_restante: int = tiempo_inicial

func set_health(value: int):
	health_bar.value = value

func set_time(value: int):
	time_bar.value = value

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]  
		player.connect("health_changed", Callable(self, "_on_player_health_changed"))
		player.connect("time_changed", Callable(self, "_on_player_time_changed"))
		set_health(player.vida)
		
		set_time(player.tiempo)
	else:
		print("⚠️ No se encontró ningún nodo en el grupo 'player'")
		
	$Timer.star()

func _on_player_health_changed(value: int):
	set_health(value)

func _on_player_time_changed(value: int):
	set_time(value)

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
