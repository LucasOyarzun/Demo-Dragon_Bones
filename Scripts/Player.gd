extends KinematicBody2D
class_name Player

var lineal_vel = Vector2()
var speed_x = 300
var speed_y = 400
var gravity = 25*60

var max_jumps = 1
var jumps = 0
var doubleJump = false

var max_airborne_time = 0.2
var airborne_time = 0

var facing_right = true
var limite_pantalla

var attacking = false

var crouched = false
var crouched_factor = 0.6

var on_floor = false

var hp = 3
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
	$Invulnerability.connect("timeout", self, "on_timeout")
	limite_pantalla = get_viewport_rect().size
	create_lifes()
	
	
func _physics_process(delta: float) -> void:
	lineal_vel = move_and_slide_with_snap(lineal_vel, snap, Vector2.UP)
	lineal_vel.y += gravity*delta
	
	on_floor = is_on_floor()
	
	if on_floor:
		snap = Vector2.DOWN*20 
	var target_vel = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	# Airborne_Time
	if on_floor:
		doubleJump = false
		airborne_time = 0
		jumps = 0
	else:
		airborne_time += delta
	
	# Jump
	if Input.is_action_just_pressed("jump") and jumps < max_jumps:
		if on_floor or airborne_time < max_airborne_time:
			lineal_vel.y = -speed_y
			snap = Vector2.ZERO
		if jumps == 1:
			lineal_vel.y = -speed_y
			doubleJump = true
			snap = Vector2.ZERO
		jumps += 1
			
			
	#Ataque
	if hp !=1:
		if Input.is_action_just_pressed("attack"):
			self.hp -= 1         # Disminuye la vida
			if hp == 0:
				die()
			lifes_list[hp].queue_free() # Quita la lutima vida
			lifes_list.pop_back()
			attacking = true

		
	# Dash 
	# hay que cambiar 
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
		
		for child in $CeilingCheck.get_children():
			child.enabled = crouched
			
	# Animations
	if attacking:
		#print(playback.get_current_node())
		if playback.get_current_node() in ["Bend_Walk","Idle_Bend"]:
			playback.travel("Bend_Attack")
		else:
			playback.travel("MeleeAttack")
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
		
# Vida
func create_lifes():
	for i in hp: # Creamos las vidas iniciales
		var newLife = sprite_hp.instance()
		get_tree().get_nodes_in_group("gui")[0].add_child(newLife)
		newLife.global_position.x +=offset_lifes * i
		lifes_list.append(newLife)
		
func take_damage(damage):
	if not can_take_damage:
		return
	self.hp -= damage           # Disminuye la vida
	if hp == 0:
		die()
	lifes_list[hp].queue_free() # Quita la lutima vida
	lifes_list.pop_back()
	can_take_damage = false
	$Invulnerability.start()
	$FramesInv.play("flashes") # Frames de invulnerabilidad

func knockback(knockdir):
	if can_take_damage:
		knockdir.y = knockdir.y * 0.5
		lineal_vel = knockdir * 20
	

func on_timeout():
	can_take_damage = true
	

func add_life():
	var newLife = sprite_hp.instance()
	get_tree().get_nodes_in_group("gui")[0].add_child(newLife)
	newLife.global_position.x += offset_lifes * (hp)
	lifes_list.append(newLife)
	hp += 1         # Aumentamos la vida
		
		
func die():
	get_tree().reload_current_scene()

func set_jumps_number(number):
	max_jumps = number

func _input(event: InputEvent)-> void:
	var just_pressed = event.is_pressed() and not event.is_echo()
	if event.is_action_pressed("menu") and just_pressed:
		$PauseMenu.toggle()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name in ["MeleeAttack","Bend_Attack"]:
		attacking = false


func _on_MeleeHit_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"): # Si choca con un enemigo
		body.take_damage()
