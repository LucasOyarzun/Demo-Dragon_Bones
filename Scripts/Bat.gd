extends KinematicBody2D


var lineal_vel = Vector2()
export var speed_x = 100 

var facing_right = false
var waiting_before_turn_back = 0

onready var area = $Area2D.connect("body_entered", self, "on_body_entered")
onready var sprite = $AnimatedSprite
var target_vel = -1
var moving = false
var timer_moving = 0
var moving_lapse = rand_range(1, 6)
var stay_lapse = 1.2

func _ready():
	sprite.play()
	$TurnBack.connect("timeout", self, "turn_back")
	$TurnBack.start()
	$TurnBack.wait_time = rand_range(1,2)
func _physics_process(delta: float) -> void:
	lineal_vel.y=0
	lineal_vel = move_and_slide(lineal_vel, Vector2.UP)
	
	waiting_before_turn_back-=delta
	timer_moving+=delta
	
	# Move
	lineal_vel.x = lerp(lineal_vel.x, target_vel * speed_x, 0.5)

func on_body_entered(body: Node):
	if body.is_in_group("player"): # Si choca con el jugador
		var player: Player = body
		var knockdir = player.transform.origin - transform.origin # Knockback
		player.knockback(knockdir)
		player.take_damage(1)

func turn_back():
	facing_right = !(facing_right)
	scale.x = -1
	target_vel = -target_vel
func take_damage():
	queue_free()
