extends KinematicBody2D

var lineal_vel = Vector2()
var speed_x = 100 + rand_range(0, 50) # Between 100 and 200
var speed_y = 500
var gravity = 20

var facing_right = false
var waiting_before_turn_back = 0

onready var playback = $AnimationTree.get("parameters/playback")
onready var area = $Area2D.connect("body_entered", self, "on_body_entered")
var target_vel = -1
var moving = false
var timer_moving = 0
var moving_lapse = rand_range(1, 6)
var stay_lapse = 1.2

var Cura = preload("res://Scenes/Cura.tscn")
	
func _physics_process(delta: float) -> void:
	lineal_vel = move_and_slide(lineal_vel, Vector2.UP)
	lineal_vel.y += gravity
	waiting_before_turn_back-=delta
	timer_moving+=delta
	
	if is_on_floor():
		lineal_vel.x = lerp(lineal_vel.x, target_vel * speed_x, 0.5)
	else:
		lineal_vel.x = lerp(lineal_vel.x, target_vel * speed_x, 0.1)
		
	if not(moving):
		lineal_vel.x = 0
		
	if(timer_moving> stay_lapse and moving == false):
		moving = true
		timer_moving = 0
	elif(timer_moving> moving_lapse and moving ==true):
		moving = false
		timer_moving = 0
		
	# Para que de vueltas en la plataforma
	if !$RayCast2D.is_colliding() or $RayCast2D2.is_colliding():
		if(waiting_before_turn_back<0):
			waiting_before_turn_back= 0.5
			facing_right = !(facing_right)
			scale.x = -1
			target_vel = -target_vel
		
	
	# Animations
	if is_on_floor():
		if abs(lineal_vel.x) > 10:
			playback.travel("Walk")
		else:
			playback.travel("Idle")

func on_body_entered(body: Node):
	if body.is_in_group("player"): # Si choca con el jugador
		var player: Player = body
		var knockdir = player.transform.origin - transform.origin # Knockback
		player.knockback(knockdir)
		player.take_damage(1)

func spawn_bone():
		# Genera un nuevo Hueso
	var cura = Cura.instance()           # Instanciamos la escena Cura
	get_parent().add_child(cura)           # Lo agregamos como hijo de main para que no se mueva con el worm
	cura.global_position = global_position - Vector2(0,10)
	cura.set_lineal_vel(100)

func take_damage():
	spawn_bone()
	queue_free()
	
