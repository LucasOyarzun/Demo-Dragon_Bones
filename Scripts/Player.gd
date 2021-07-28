extends KinematicBody2D
class_name Player

var lineal_vel = Vector2()
var speed_x = 300
var speed_y = 400
var speed_climb = 100
var gravity = 25*60

var max_jumps = 1
var jumps = 0
var doubleJump = false

var max_airborne_time = 0.15
var airborne_time = 0

var facing_right = true
var limite_pantalla

var attacking = false

var crouched = false
var crouched_factor = 0.6

var on_floor = false

var can_climb = false
var climbing = false
var climb_pressed = false

var live = true
var offset_lifes = 50
var lifes_list = []                 # Lista de vidas
export (PackedScene) var sprite_hp  # Sprite de vidas
var can_take_damage = true

# Snap for diagonals
var snap = Vector2.DOWN*20 

onready var playback = $AnimationTree.get("parameters/playback")

# Lava position
var lava_subiendo_pos

func _ready():
	$TimerAgarre.connect("timeout", self, "recuperar_agarre")
	$Invulnerability.connect("timeout", self, "on_timeout")
	limite_pantalla = get_viewport_rect().size
	create_lifes()
	var topleft = get_parent().get_node("Margen/Top_left")
	var botright = get_parent().get_node("Margen/Bottom_right")
	$Cam.limit_top = topleft.global_position.y
	$Cam.limit_left = topleft.global_position.x
	$Cam.limit_bottom = botright.global_position.y
	$Cam.limit_right = botright.global_position.x

func _physics_process(delta: float) -> void:
	lineal_vel = move_and_slide_with_snap(lineal_vel, snap, Vector2.UP)
	
	if $Climb.get_overlapping_bodies() != []:
		if $Climb.get_overlapping_bodies()[0].is_in_group("map") and on_floor == false and can_climb and climb_pressed: #choca con el mapa
			climbing = true
			
	# Climbing
	if Input.is_action_just_pressed("climb") or Input.is_action_pressed("climb"):
		climb_pressed = true
	if Input.is_action_just_released("climb"):
		climb_pressed = false
		
	if climbing == false:
		lineal_vel.y += gravity*delta
	
	on_floor = is_on_floor()
	
	if on_floor:
		snap = Vector2.DOWN*20 
	var target_vel = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var climb_vel = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Airborne_Time
	if on_floor:
		doubleJump = false
		airborne_time = 0
		jumps = 0
	else:
		airborne_time += delta

	#Ataque
	if GlobalVars.hp !=1:
		if Input.is_action_just_pressed("attack"):
			GlobalVars.hp -= 1         # Disminuye la vida
			if GlobalVars.hp == 0:
				die()
			lifes_list[GlobalVars.hp].queue_free() # Quita la ultima vida
			lifes_list.pop_back()
			attacking = true

	# Jump
	if Input.is_action_just_pressed("jump") and jumps < max_jumps:
		if on_floor or airborne_time < max_airborne_time: # Primer salto
			lineal_vel.y = -speed_y
			snap = Vector2.ZERO
			$Sounds/Jump.play()
			
		elif climbing: # Si esta escalando
			snap = Vector2.ZERO
			lineal_vel.y = -speed_y
			$TimerAgarre.start()
			$Climb/CollisionShape2D.disabled = true
			$Sounds/Jump.play()
			climbing =false
			
		else: #Si se deja caer, pero tiene doble salto
			if jumps+1 < max_jumps:
				lineal_vel.y = -speed_y
				jumps +=1
				doubleJump = true
				playback.travel("DoubleJump")
				snap = Vector2.ZERO
				$Sounds/DoubleJump.play()
		if jumps>=1:# Si ya saltó
			lineal_vel.y = -speed_y
			doubleJump = true
			snap = Vector2.ZERO
			$Sounds/DoubleJump.play()
		
		jumps += 1
	
	if Input.is_action_just_released("climb") and climbing:
		if on_floor:
			playback.travel("Idle")
		else:
			playback.travel("Jump_Down")
		climbing = false
		
			
	# Dash 
	# hay que cambiar 
	if Input.is_action_just_pressed("dash"):
		lineal_vel = (get_global_mouse_position() - global_position).normalized() * 2 * speed_x
		snap = Vector2.ZERO

	# Movement
	var ceiling = false
	
	for child in $CeilingCheck.get_children():
		if child.is_colliding():
			ceiling = true
			break

	var last_crouched = crouched
	crouched = on_floor and Input.is_action_pressed("ui_down") or ceiling
	
	if climbing:
		doubleJump = false
		airborne_time = 0
		jumps = 0
		lineal_vel.y = lerp(lineal_vel.y, climb_vel * speed_climb, 0.8)

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
			($CollisionShape2D.shape as CapsuleShape2D).height = 10
		else:
			$CollisionShape2D.position.y = 9
			($CollisionShape2D.shape as CapsuleShape2D).height = 25
		for child in $CeilingCheck.get_children():
			child.enabled = crouched
	
	
		
	# Animations
	if attacking:
		if playback.get_current_node() in ["Bend_Walk","Idle_Bend"]:
			playback.travel("Bend_Attack")
		elif playback.get_current_node() in ["Climb_Ready","Climb_Up"]:
			playback.travel("Climb_Attack")
		else:
			playback.travel("MeleeAttack")
	elif climbing:
		if abs(lineal_vel.y) > 50:
			playback.travel("Climb_Up")
		else:
			playback.travel("Climb_Ready")
	else:
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
				if doubleJump:
					playback.travel("DoubleJump")
				else:
					playback.travel("Jump_Up")
			else:
				playback.travel("Jump_Down")

func recuperar_agarre():
	$Climb/CollisionShape2D.disabled = false
# Vida
func create_lifes():
	for i in GlobalVars.hp: # Creamos las vidas iniciales
		var newLife = sprite_hp.instance()
		get_tree().get_nodes_in_group("gui")[0].add_child(newLife)
		newLife.global_position.x +=offset_lifes * i
		lifes_list.append(newLife)

func take_damage(damage):
	if not can_take_damage:
		return
	GlobalVars.hp -= damage           # Disminuye la vida
	lifes_list[GlobalVars.hp].queue_free() # Quita la lutima vida
	lifes_list.pop_back()
	if GlobalVars.hp == 0:
		die()
	can_take_damage = false
	$Invulnerability.start()
	$FramesInv.play("flashes") # Frames de invulnerabilidad

func knockback(knockdir):
	if can_take_damage:
		knockdir.y = knockdir.y * 0.5
		lineal_vel = knockdir * 20

func on_timeout():
	can_take_damage = true

func add_life(pickup=false):
	var newLife = sprite_hp.instance()
	get_tree().get_nodes_in_group("gui")[0].add_child(newLife)
	newLife.global_position.x += offset_lifes * (GlobalVars.hp)
	lifes_list.append(newLife)
	GlobalVars.hp += 1         # Aumentamos la vida
	if pickup:
		$Sounds/PickUp.play()

func die():
	self.live = false
	$FadeOut/FadeOutAnim.play("FadeOut")
	
func fade_out():
	$FadeOut/FadeOutAnim.play("FadeOut")

func _on_FadeOutAnim_animation_finished(anim_name: String) ->void:
	if live:
		$FadeOut/FadeOutColor.color = 00000000
	else:
		get_tree().reload_current_scene()
		GlobalVars.hp = 3
		$FadeOut/FadeOutColor.color = 00000000
	
func get_hp():
	return GlobalVars.hp

func set_jumps_number(number):
	max_jumps = number
func set_can_climb(value):
	can_climb = value

func _input(event: InputEvent)-> void:
	var just_pressed = event.is_pressed() and not event.is_echo()
	if event.is_action_pressed("menu") and just_pressed:
		$PauseMenu.toggle()

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name in ["MeleeAttack","Bend_Attack","Climb_Attack"]:
		attacking = false

func _on_MeleeHit_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"): # Si choca con un enemigo
		body.take_damage()

func _on_Climb_body_entered(body: Node) -> void:
	if body.is_in_group("map") and on_floor == false and can_climb and climb_pressed: #choca con el mapa
		climbing = true


func _on_Climb_body_exited(body: Node) -> void:
	if body.is_in_group("map"): #choca con el mapa
		if on_floor:
			playback.travel("Idle")
		else:
			playback.travel("Jump_Down")
		climbing = false



