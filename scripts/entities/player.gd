extends CharacterBody2D
signal health_changed(vida)
signal energy_changed(energia)
@export var speed: float = 300
@export var vida: int = 100
@export var tiempo: int = 60
var atontado: bool = false
var tiempo_atontado: Timer

func _ready():
	$Area2D.connect("area_entered",Callable(self,"_on_area_entered"))
	
	time = Timer.new()
	add_child(time)
	time.wait_time = 1
	time.autostart = true
	time.connect("timeout", self, "_on_time_timeout")

	tiempo_atontado = Timer.new()
	add.child(tiempo_atontado)
	tiempo_atontado.connect("timeout", self, "_on_atontado_timeout")
	
func _physics_process(delta):
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized() * speed

	velocity = input_vector
	move_and_slide()

	# Flip del sprite (opcional)
	if velocity.x != 0:
		$Sprite.flip_h = velocity.x < 0


func _on_area_entered(area):
	
	if area is Food:
		consumir_comida(area.bonus)
		area.queue_free()
		return
	
	var obstacle_node = area.get_parent()
	if obstacle_node.has_method("get_obstacle_info"):
		var info = obstacle_node.get_obstacle_info()
		quitar_vida(info.damage)
	
func quitar_vida(cantidad: int):
	vida -= cantidad
	emit_signal("health_changed", vida)
	print("Vida actual",vida)
	if vida <= 0:
		morir()

func consumir_comida(bonus: int):
	tiempo += bonus
	emit_signal("time_changed", tiempo)  # Emitimos la señal
	print("Comiste algo. Tiempo actual: %d" % tiempo)
	
func atontar():
	atontado = true
	tiempo_atontado.start(3)

func _on_atontado_timeout():
	atontado = false
	print("Ya no estás atontado")
	
func _on_time_timeout():
	tiempo -= 10
	emit_signal("time_changed", tiempo)
	if tiempo <= 0:
		game_over_se_acabo_el_tiempo()

func game_over_se_acabo_el_tiempo():
	print("GAME OVER se te acabó el tiempo")

func  morir():
	print("El jugador ha muerto.")
