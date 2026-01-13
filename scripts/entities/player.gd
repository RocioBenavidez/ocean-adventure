extends CharacterBody2D

signal health_changed(vida)
signal comer_comida(tiempo_extra)
signal player_died

@export var speed: float = 400
@export var vida: int = 100
@export var energia: int = 0
@onready var animated_sprite: AnimatedSprite2D = $AnimateSprite
@onready var game_over_scene = preload("res://escenas/screens/GameOverScreen.tscn")

var muerto: bool = false  

func _ready():
	$Area2D.connect("area_entered", Callable(self, "_on_area_entered"))
	animated_sprite.play("nadando")
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))


func _physics_process(_delta):
	if muerto:
		velocity = Vector2.ZERO  
		return

	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized() * speed

	velocity = input_vector
	move_and_slide()

	if velocity.x != 0:
		$AnimateSprite.flip_h = velocity.x < 0


func consumir_comida():
	animated_sprite.play("comiendo")


func _on_area_entered(area):
	if muerto:
		return  

	if area is Food:
		emit_signal("comer_comida", area.bonus)
		consumir_comida()
		Global.sum_score()
		area.queue_free()
		return
	
	var obstacle_node = area.get_parent()
	if obstacle_node.has_method("get_obstacle_info"):
		var info = obstacle_node.get_obstacle_info()
		quitar_vida(info["damage"])
		Global.rest_score()


func quitar_vida(cantidad: int):
	if muerto:
		return

	vida -= cantidad
	emit_signal("health_changed", vida)
	animated_sprite.play("atontado")

	if vida <= 0:
		morir()


func morir():
	if muerto:
		return  
	muerto = true
	animated_sprite.play("dead")

	# Desactivar colisiones de forma segura
	$CollisionShape2D.set_deferred("disabled", true)

	# Desactivar física de forma segura
	set_deferred("physics_process", false)

	await get_tree().create_timer(1.2).timeout

	emit_signal("player_died")


func _on_animation_finished():
	if muerto:
		return  # ← No volver a animar si está muerto
	if animated_sprite.animation in ["comiendo", "atontado"]:
		animated_sprite.play("nadando")
