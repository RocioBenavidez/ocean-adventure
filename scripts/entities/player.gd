extends CharacterBody2D

signal health_changed(vida)
signal comer_comida(tiempo_extra)

@export var speed: float = 300
@export var vida: int = 100


func _ready():
	$Area2D.connect("area_entered",Callable(self,"_on_area_entered"))
	
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

func consumir_comida(food: int):
	emit_signal("time_changed", food)  # HUD recibirá esto y sumará tiempo
	print("Comiste algo. Se agregó tiempo extra: %d" % food)

func _on_area_entered(area):
	if area is Food:
		emit_signal("comer_comida", area.bonus)
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

func  morir():
	print("El jugador ha muerto.")
