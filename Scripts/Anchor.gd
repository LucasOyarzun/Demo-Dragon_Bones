extends Position2D

onready var player = get_node("../Player")

func _process(delta):
	var target = player.global_position
	var target_pos_x
	var target_pos_y
	target_pos_x = int(lerp(global_position.x, target.x, 0.1))
	target_pos_y = int(lerp(global_position.y, target.y, 0.1))
	global_position = Vector2(target_pos_x, target_pos_y)
