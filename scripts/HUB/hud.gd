extends CanvasLayer

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var score_label = $ScoreLabel


func set_health(value: int):
	health_bar.value = value

func update_score(value: int):
	score_label.text = "Puntos: %s" % value

func _ready():
	# Busca el primer nodo en el grupo "player"
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]  # en tu juego seguramente haya solo 1
		player.connect("health_changed", Callable(self, "_on_player_health_changed"))
		set_health(player.vida)  # inicializar la barra
		
	else:
		print("⚠️ No se encontró ningún nodo en el grupo 'player'")
		
	var timer_node = get_node("/root/HUB/timerGame")  # Asegúrate de tener la ruta correcta
	if timer_node:
		timer_node.connect("timer_updated", Callable(self, "_on_timer_updated"))
		
	else:
		print("⚠️ No se encontró el nodo de cronómetro.")
		


func _on_player_health_changed(value):
	set_health(value)

func _on_timer_updated(minutes, seconds, msec, puntos):
	# Actualiza el texto del cronómetro
	$Minutes2.text = "%02d" % minutes
	$Seconds2.text = "%02d" % seconds
	$Msecs2.text = "%03d" % msec
	
	# Actualiza los puntos


func _on_timer_game_ready() -> void:
	pass # Replace with function body.
