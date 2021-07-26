extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Intro.play("Intro_completa")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Intro_animation_finished(anim_name):
	get_tree().change_scene("res://Scenes/Level1_Tutorial.tscn")
