extends KinematicBody2D
class_name Player

var lineal_vel = Vector2()
var speed = 400
var gravity = 20

var max_jumps = 2
var jumps = 0

var max_airborne_time = 10
var airborne_time = 0

var facing_right = true

onready var playback = $AnimationTree.get("parameters/playback")

func _physics_process(delta: float) -> void:
	
	lineal_vel = move_and_slide(lineal_vel, Vector2.UP)
	lineal_vel.y += gravity
	
	var on_floor = is_on_floor()
	
	var target_vel = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if on_floor:
		airborne_time = 0
		jumps = 0
	else:
		airborne_time += delta
	
	if Input.is_action_just_pressed("jump") and jumps < max_jumps:
		if on_floor or airborne_time < max_airborne_time:
			lineal_vel.y = -speed
			jumps += 1
	
	if Input.is_action_just_pressed("dash"):
		lineal_vel = (get_global_mouse_position() - global_position).normalized() * 2 * speed
	
	if on_floor:
		lineal_vel.x = lerp(lineal_vel.x, target_vel * speed, 0.5)
	else:
		lineal_vel.x = lerp(lineal_vel.x, target_vel * speed, 0.1)
	
	if Input.is_action_just_pressed("move_left") and facing_right:
		facing_right = false
		scale.x = -1
	if Input.is_action_just_pressed("move_right") and not facing_right:
		facing_right = true
		scale.x = -1
		
	# Animations
	if abs(lineal_vel.x) > 10:
		playback.travel("Run")
	else:
		playback.travel("Idle")

