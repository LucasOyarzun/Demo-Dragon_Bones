extends Node2D

func _ready():
	get_node("Player").set_jumps_number(2)
	$StartFade/AnimationPlayer.play("Start")
	$StartFade/ColorRect.color = 000000
