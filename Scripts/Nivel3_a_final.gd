extends Area2D

func _ready():
	connect("body_entered",self,"on_body_entered" )
	
func on_body_entered(body: Node):
	if body.is_in_group("player"):
		while body.get_hp() < 3:
			body.add_life()
		get_tree().change_scene("res://Scenes/Main.tscn") # Debe ir a escena final
		
