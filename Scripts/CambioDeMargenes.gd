extends Area2D

func _on_CambioDeMargenes_body_entered(body):
	if body.is_in_group("player"):
		var camara:Camera2D = body.get_node("Cam")
		camara.drag_margin_bottom=0.5
		camara.drag_margin_right=0.5
		camara.drag_margin_top=0.5
		camara.drag_margin_left=0.5
