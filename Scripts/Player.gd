extends KinematicBody2D
class_name Player

var lineal_vel = Vector2()
var speed_x = 300
var speed_y = 400
var gravity = 25

var max_jumps = 2
var jumps = 0

var max_airborne_time = 10
var airborne_time = 0

var facing_right = true
var limite_pantalla


var crouched = false
var crouched_factor = 0.6

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
	
	
	var ceiling = false
	
	for child in $CeilingCheck.get_children():
		if child.is_colliding():
			ceiling = true
			break
	
	var last_crouched = crouched
	crouched = on_floor and Input.is_action_pressed("ui_down") or ceiling
	
	if on_floor:
		lineal_vel.x = lerp(lineal_vel.x, target_vel * speed_x * (crouched_factor if crouched else 1.0), 0.5)
	else:
		lineal_vel.x = lerp(lineal_vel.x, target_vel * speed_x, 0.1)
		
	if Input.is_action_just_pressed("move_left") and facing_right:
		facing_right = false
		scale.x = -1
	if Input.is_action_just_pressed("move_right") and not facing_right:
		facing_right = true
		scale.x = -1
	
	

	
	
	if crouched != last_crouched:
		if crouched:
			$CollisionShape2D.position.y = 16
			($CollisionShape2D.shape as CapsuleShape2D).height = 2
		else:
			$CollisionShape2D.position.y = 9
			($CollisionShape2D.shape as CapsuleShape2D).height = 16
		
#		if crouched:
#			$APCollisionShape.play("crouched")
#		else:
#			$APCollisionShape.play("standing")
		for child in $CeilingCheck.get_children():
			child.enabled = crouched
	
	# Animations
	if on_floor:
		if abs(lineal_vel.x) > 30:
			if crouched:
				playback.travel("Bend_Walk")
			else:
				playback.travel("Walk")
		else:
			if crouched:
				playback.travel("Idle_Bend")
			else:
				playback.travel("Idle")
	else:
		if lineal_vel.y < 0:
			playback.travel("Jump_Up")
		else:
			playback.travel("Jump_Down")


func _input(event: InputEvent)-> void:
	var just_pressed = event.is_pressed() and not event.is_echo()
	if event.is_action_pressed("menu") and just_pressed:
		$PauseMenu.toggle()
