extends Area2D

func _ready():
	connect("body_entered", self, "on_body_entered") # self porque la funcion está en mi mismo

func on_body_entered(body: Node):
	if body.is_in_group("player"): # Si choca con el jugador
		var player: Player = body
		player.set_can_climb(true)
		queue_free()
