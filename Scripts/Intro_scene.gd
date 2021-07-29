extends Node2D

func _ready():
	$Intro.play("Intro_completa")
	$AudioStreamPlayer.play()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		skip_scene()

func _on_Intro_animation_finished(anim_name):
	skip_scene()
	
func skip_scene():
	get_tree().change_scene("res://Scenes/Level1_Tutorial.tscn")
