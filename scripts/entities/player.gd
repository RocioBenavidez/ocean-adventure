extends CharacterBody2D

signal health_changed(vida)
signal comer_comida(tiempo_extra)

@export var speed: float = 300
@export var vida: int = 50
@export var energia: int = 0
@onready var animated_sprite: AnimatedSprite2D = $AnimateSprite


func _ready():
	$Area2D.connect("area_entered",Callable(self,"_on_area_entered"))
	animated_sprite.play("nadando")
	# Conectar señal para saber cuando termina una animación
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
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
		$AnimateSprite.flip_h = velocity.x < 0

func consumir_comida(food: int):
	emit_signal("time_changed", food)  # HUD recibirá esto y sumará tiempo
	print("Comiste algo. Se agregó tiempo extra: %d" % food)
	animated_sprite.play("comiendo")

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
	animated_sprite.play("atontado")
	if vida <= 0:
		morir()

	
func  morir():
	print("El jugador ha muerto.")
	animated_sprite.play("dead")

func _on_animation_finished():
	# Solo volver a "nadando" si estaba en comiendo o atontado
	if animated_sprite.animation in ["comiendo", "atontado"]:
		animated_sprite.play("nadando")
