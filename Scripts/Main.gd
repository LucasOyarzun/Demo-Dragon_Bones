extends Node2D

var lava_subiendo_pos
onready var camera = get_node("Player/Cam")

func _ready():
	$StartFade/AnimationPlayer.play("Start")
	$StartFade/ColorRect.color = 000000
func _physics_process(delta: float) -> void:
	# mantiene la posicion de la lava que sube
	lava_subiendo_pos = get_node("Lava_subiendo").position.y
	
	camera.limit_bottom = min(lava_subiendo_pos, 700)
	
	
