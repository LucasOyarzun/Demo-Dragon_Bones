extends Node2D


func _ready():
	
	$AudioStreamPlayer.play()
	$Final.play("Final_completo")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		skip_scene()

	
func skip_scene():
	get_tree().change_scene("res://Scenes/Creditos.tscn")


func _on_Final_animation_finished(anim_name):
	skip_scene()
