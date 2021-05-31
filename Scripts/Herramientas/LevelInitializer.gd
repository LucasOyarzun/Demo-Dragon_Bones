# 
tool
extends EditorScript


func _run():
	var scene = get_scene()
	var enemies = Node.new()
	enemies.name = "Enemies"
	scene.add_child(enemies)
	enemies.owner	= scene
