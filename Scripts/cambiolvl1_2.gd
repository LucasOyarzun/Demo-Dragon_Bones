extends Area2D

func _ready():
	connect("body_entered",self,"on_body_entered" )
	$Music_Fade.play("Nueva Animación")
func on_body_entered(body: Node):
	if body.is_in_group("player"):
		body.fade_out()
		while body.get_hp() < 3:
			body.add_life()
		get_tree().change_scene("res://Scenes/Nivel3_Esofago.tscn")
