extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
var puntos: int = 0

func _ready():
	set_score(0)

func set_score(value: int):
	puntos = value
	score_label.text = "SCORE: %d" % puntos

func add_points(amount: int):
	puntos += amount
	set_score(puntos)
