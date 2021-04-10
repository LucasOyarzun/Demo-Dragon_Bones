extends KinematicBody2D
class_name Player

var lineal_vel = Vector2()
var speed_x = 300
var speed_y = 500
var gravity = 20

var max_jumps = 2
var jumps = 0

var max_airborne_time = 10
var airborne_time = 0

var facing_right = true
var limite_pantalla

onready var playback = $AnimationTree.get("parameters/playback")

func _ready():
	limite_pantalla = get_viewport_rect().size
	
func _physics_process(delta: float) -> void:
	
	lineal_vel = move_and_slide(lineal_vel, Vector2.UP)
	lineal_vel.y += gravity
	
	var on_floor = is_on_floor()
	var target_vel = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	# Airborne_Time
	if on_floor:
		airborne_time = 0
		jumps = 0
	else:
		airborne_time += delta
	
	# Jump
	if Input.is_action_just_pressed("jump") and jumps < max_jumps:
		if on_floor or airborne_time < max_airborne_time:
			lineal_vel.y = -speed_y
			jumps += 1
	
	# Dash
	if Input.is_action_just_pressed("dash"):
		lineal_vel = (get_global_mouse_position() - global_position).normalized() * 2 * speed_x
		
	
		
	# Movement
	if on_floor:
		if Input.is_action_pressed("ui_down"): # If skeleton is crouched
			lineal_vel.x = lerp(lineal_vel.x, target_vel * speed_x, 0.5)*0.6
		else:	
			lineal_vel.x = lerp(lineal_vel.x, target_vel * speed_x, 0.5)
	else:
		lineal_vel.x = lerp(lineal_vel.x, target_vel * speed_x, 0.1)
		
	if Input.is_action_just_pressed("move_left") and facing_right:
		facing_right = false
		scale.x = -1
	if Input.is_action_just_pressed("move_right") and not facing_right:
		facing_right = true
		scale.x = -1
		
	# Animations
	if on_floor:
		if abs(lineal_vel.x) > 30:
			if Input.is_action_pressed("ui_down"):
				playback.travel("Bend_Walk")
			else:
				playback.travel("Walk")
		else:
			if Input.is_action_pressed("ui_down"):
				playback.travel("Idle_Bend")
			else:
				playback.travel("Idle")
	else:
		if lineal_vel.y < 0:
			playback.travel("Jump_Up")
		else:
			playback.travel("Jump_Down")

