extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "on_body_entered") # self porque la funcion está en mi mismo

func on_body_entered(body: Node):
	if body.is_in_group("player"): # Si choca con el jugador
		var player: Player = body
		player.die()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
