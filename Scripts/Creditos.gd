extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Transition.play("Up")
	$AudioStreamPlayer.play()
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		skip_scene()
		
func skip_scene():
	get_tree().change_scene("res://Scenes/Menu.tscn")
