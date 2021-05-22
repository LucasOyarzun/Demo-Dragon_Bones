extends Area2D

var speed_y = 20
var lineal_vel = Vector2()

func _ready():
	connect("body_entered", self, "on_body_entered") # self porque la funcion está en mi mismo
	$Stop.connect("timeout", self, "stop")
	$Start.connect("timeout", self, "start")
	start()
	

func on_body_entered(body: Node):
	if body.is_in_group("player"): # Si choca con el jugador
		var player: Player = body
		player.die()
		
func _physics_process(delta: float) -> void:
#	lineal_vel = move_and_slide(lineal_vel, Vector2.UP)
	position += lineal_vel*delta
	
func stop():
	lineal_vel.y = 0
	$Start.start()
	
func start():
	lineal_vel.y = -speed_y
	$Stop.start()
