extends Node2D

func _ready():
	$StartFade/AnimationPlayer.play("Start")
	$StartFade/ColorRect.color = 000000
