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
		
func _on_player_health_changed(value):
	set_health(value)
