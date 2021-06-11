extends CanvasLayer

func _ready() -> void:
	$Panel/VBoxContainer/Start.connect("pressed",self,"_on_start_pressed")
	$Panel/VBoxContainer/Exit.connect("pressed",self,"_on_Exit_pressed")
	
func _on_start_pressed():
	get_tree().change_scene("res://Scenes/Level1_Tutorial.tscn")
	
func _on_Exit_pressed():
	get_tree().quit()
