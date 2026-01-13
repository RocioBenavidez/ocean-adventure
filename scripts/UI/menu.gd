extends Control

signal start_game

@onready var name_input: LineEdit = $VBoxContainer/name_input
@onready var ranking_panel = $Ranking

func _ready():
	set_anchors_preset(Control.PRESET_FULL_RECT)
	ranking_panel.visible = false
	print("Menú cargado correctamente")

func _on_play_pressed():
	var nombre = name_input.text.strip_edges()
	if nombre == "":
		nombre = "Jugador"
	emit_signal("start_game", nombre)

func _on_ranking_pressed():
	ranking_panel.visible = true
	ranking_panel.connect("back_to_menu", Callable(self, "_on_back_from_ranking"))
	
func _on_back_from_ranking():
	ranking_panel.visible = false
