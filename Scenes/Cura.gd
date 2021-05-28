extends Area2D

func _ready():
	connect("body_entered", self, "on_body_entered")

func on_body_entered(body: Node):
	if body.is_in_group("player"): # Si choca con el jugador
		var player: Player = body
		player.set_jumps_number(2)
		queue_free()	
