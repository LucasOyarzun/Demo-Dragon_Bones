extends CanvasLayer

func _ready() -> void:
	$PanelContainer/VBoxContainer/Continue.connect("pressed",self,"_on_Continue_pressed")
	$PanelContainer/VBoxContainer/Retry.connect("pressed",self,"_on_Retry_pressed")
	$PanelContainer/VBoxContainer/Exit_to_title.connect("pressed",self,"_on_Exit_to_title_pressed")
	
func _on_Continue_pressed():
	get_tree().paused = false
	hide()
	
func _on_Retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_Exit_to_title_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/Menu.tscn")
	
func show():
	$PanelContainer.show()
	get_tree().paused = true
func hide():
	$PanelContainer.hide()
	get_tree().paused = false
func toggle():
	if $PanelContainer.visible :
		hide()
	else:
		show()
