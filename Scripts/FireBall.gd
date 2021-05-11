extends Area2D

var speed = 150


# Called when the node enters the scene tree for the first time.
func _ready():
	# Conexion a si mismo
	connect("body_entered", self, "on_body_entered") # self porque la funcion está en mi mismo
	
func on_body_entered(body: Node):
	if body.is_in_group("player"):
		print("owo")
		queue_free() # Me destruyo a mi mismo
func _physics_process(delta):
	position +=Vector2(cos(rotation), sin(rotation)) * speed * delta
	
	
