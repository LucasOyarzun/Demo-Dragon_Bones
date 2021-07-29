extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Fade_out.color = 00000000
	$Transition.play("Up")
	$AudioStreamPlayer.play()
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		skip_scene()
		
func skip_scene():
	$Transition.play("Fade_out")

func _on_Transition_animation_finished(anim_name):
	if anim_name == "Fade_out":
		get_tree().change_scene("res://Scenes/Menu.tscn")
