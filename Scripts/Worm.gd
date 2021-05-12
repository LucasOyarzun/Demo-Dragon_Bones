extends KinematicBody2D

var lineal_vel = Vector2()
var speed_x = 100 + rand_range(0, 50) # Between 100 and 200
var speed_y = 500
var gravity = 20

var facing_right = false
var waiting_before_turn_back = 0

onready var playback = $AnimationTree.get("parameters/playback")
var target_vel = -1
var moving = false                  # Variable de si se mueve o no
var timer_moving = 0                # Tiempo que lleva moviendose o quieto
var moving_lapse = rand_range(1, 4) # Tiempo que se mueve
var stay_lapse = 1.2                # Tiempo que se queda quieto

var fireball_lapse = 0.4            # Tiempo que se demorará en lanzar la bola de fuego
var fireball_created = false        # Si es que ya lanzo la bola de fuego
	
# Guardamos bala como una variable
var Fireball = preload("res://Scenes/FireBall.tscn")

func _physics_process(delta: float) -> void:
	lineal_vel = move_and_slide(lineal_vel, Vector2.UP)
	lineal_vel.y += gravity
	waiting_before_turn_back-=delta                  # Tiempo antes de darse la vuelta
	timer_moving+=delta
	
	if is_on_floor():
		lineal_vel.x = lerp(lineal_vel.x, target_vel * speed_x, 0.5)
	else:
		lineal_vel.x = lerp(lineal_vel.x, target_vel * speed_x, 0.1)
		
	if not(moving):
		lineal_vel.x = 0
	
	if(timer_moving> fireball_lapse and moving == false and fireball_created == false) :   # Cuando decide lanzar la bola
		# Lanza la bola de fuego
		var fireball = Fireball.instance()           # Instanciamos la escena fireball
		get_parent().add_child(fireball)           # Lo agregamos como hijo de main para que no se mueva con el worm
		if facing_right:
			fireball.global_position = global_position+Vector2(30, 0) # Posicion inicial la de este enemigo
			fireball.rotation = 0
		else:
			fireball.global_position = global_position+Vector2(-30, 0) # Posicion inicial la de este enemigo
			fireball.rotation = PI
		fireball_created = true
		
	if(timer_moving> stay_lapse and moving == false):   # Cuando decide moverse
		moving = true
		timer_moving = 0
	elif(timer_moving> moving_lapse and moving ==true): # Cuando decide quedarse quieto
		moving_lapse = rand_range(1, 4)
		moving = false
		timer_moving = 0
		fireball_created = false
		
		
		
		
		
#	if Input.is_action_just_pressed("additional_ability1"):
	
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

	
