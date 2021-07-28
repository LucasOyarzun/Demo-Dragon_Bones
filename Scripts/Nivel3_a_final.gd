extends Area2D

func _ready():
	connect("body_entered",self,"on_body_entered" )
	$Timer.connect("timeout", self, "on_timer_out")
	$Music_Fade.play("Nueva Animación")
	
func on_body_entered(body: Node):
	if body.is_in_group("player"):
		$Timer.start()
		body.fade_out()
		while body.get_hp() < 3:
			body.add_life()

func on_timer_out():
	get_tree().change_scene("res://Scenes/Final_scene.tscn")
