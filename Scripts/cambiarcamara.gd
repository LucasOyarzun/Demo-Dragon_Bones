extends Area2D



func _on_cambiarcamara_body_entered(body):
	if body.is_in_group("player"):
		var camara:Camera2D = body.get_node("Cam")
		camara.limit_right=$Position2D.global_position.x
		camara.limit_bottom=$Position2D.global_position.y
		
