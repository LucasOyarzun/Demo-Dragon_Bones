extends KinematicBody2D

var lineal_vel = Vector2()
var speed_x = 100
var speed_y = 500
var gravity = 20

var facing_right = false
var waiting_before_turn_back = 2.5

onready var playback = $AnimationTree.get("parameters/playback")

var target_vel = -1
var moving = true
var timer_moving = 0
	
func _physics_process(delta: float) -> void:
	
	lineal_vel = move_and_slide(lineal_vel, Vector2.UP)
	lineal_vel.y += gravity
	waiting_before_turn_back-=delta
	timer_moving+=delta
	
	# Movement
	if is_on_floor():
		lineal_vel.x = lerp(lineal_vel.x, target_vel * speed_x, 0.5)
	else:
		lineal_vel.x = lerp(lineal_vel.x, target_vel * speed_x, 0.1)
	
	# Stop every some seconds
	if not(moving):
		lineal_vel.x = 0
	if(timer_moving>2.4 and moving == false):
		moving = true
		timer_moving = 0
	elif(timer_moving>6 and moving ==true):
		moving = false
		timer_moving = 0
		
	# Turn back on platform
	if $RayCast2D.is_colliding():
		pass
	else:
		if(waiting_before_turn_back<0):
			waiting_before_turn_back= 2.5
			facing_right = !(facing_right)
			scale.x = -1
			target_vel = -target_vel
	
	# Animations
	if is_on_floor():
		if abs(lineal_vel.x) > 10:
			playback.travel("Walk")
		else:
			playback.travel("Idle")
