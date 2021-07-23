extends KinematicBody2D

var lineal_vel = Vector2(0,0)
var gravedad = 5
var tiempo = 0
var can_be_touched 

func _ready():
	#connect("body_entered", self, "on_body_entered")
	$Area2D.connect("body_entered", self, "on_body_entered")
	can_be_touched = false
	$Timer.connect("timeout",self,"on_time_out")
	$Timer.start()

func on_time_out():
	can_be_touched = true

func set_lineal_vel(vel_inicial):
	lineal_vel.y = -60

func _physics_process(delta: float) -> void:
	move_and_slide(lineal_vel, Vector2.UP)
	lineal_vel.y += gravedad

func on_body_entered(body: Node):
	if can_be_touched == false:
		return
	if body.is_in_group("player"): # Si choca con el jugado
		var player: Player = body
		player.get_position_in_parent()
		player.add_life(true)
		queue_free()
