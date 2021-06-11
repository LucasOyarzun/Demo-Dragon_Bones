extends Area2D

func _ready():
	connect("body_entered",self,"on_body_entered" )
	
func on_body_entered(body: Node):
	if body.is_in_group("player"):
		get_tree().change_scene("res://Scenes/Main.tscn")
