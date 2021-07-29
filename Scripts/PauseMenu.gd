extends CanvasLayer

enum {Continue, Retry, Exit}
var option = Continue
var blockinput= true
onready var options= $Menu/PanelContainer/VBoxContainer/VBoxContainer
	
func _on_Continue_pressed():
	hide()
	get_tree().paused = false
	
	
func _on_Retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_Exit_to_title_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/Menu.tscn")
	
func show():
	blockinput = false
	$Menu.show()
	get_tree().paused = true
	$Menu/PanelContainer/Cabeza_dragon/AnimationPlayer.play("Abrir_boca")
	$Menu/PanelContainer/Cabeza_dragon2/AnimationPlayer.play("Abrir_boca")
	option = Continue
	updatelabel()
	
	
func hide():
	blockinput = true
	$Menu/PanelContainer/Cabeza_dragon/AnimationPlayer.play("Cerrar_boca")
	$Menu/PanelContainer/Cabeza_dragon2/AnimationPlayer.play("Cerrar_boca")
	yield ($Menu/PanelContainer/Cabeza_dragon/AnimationPlayer, "animation_finished")
	$Menu.hide()
	get_parent().paused = false
	get_tree().paused = false
	
func toggle():
	if $Menu.visible :
		hide()
	else:
		show()

func _input(event : InputEvent):
	if blockinput:
		if $Menu.visible:
			get_tree().set_input_as_handled()
		return
	else:
		if event.is_action_pressed("ui_up"):
			option=(option-1)%3
			$Menu/AudioStreamPlayer.play()
			updatelabel()
		if event.is_action_pressed("ui_down"):
			option=(option+1)%3
			$Menu/AudioStreamPlayer.play()
			updatelabel()
		if event.is_action_pressed("jump"):
			match option:
				Continue:
					_on_Continue_pressed()
				Retry:
					_on_Retry_pressed()
				Exit:
					_on_Exit_to_title_pressed()
		if $Menu.visible:
			get_tree().set_input_as_handled()
			

func updatelabel():
	for i in 3:
		var child = options.get_child(i)
		match i:
			Continue:
				child.parse_bbcode("[center]Continue[/center]")
				if i == option:
					child.parse_bbcode("[color=yellow][center][shake rate=10 level=10]Continue[/shake][/center][/color]")
			Retry:
				child.parse_bbcode("[center]Retry[/center]")
				if i == option:
					child.parse_bbcode("[color=yellow][center][shake rate=10 level=10]Retry[/shake][/center][/color]")
			Exit:
				child.parse_bbcode("[center]Exit[/center]")
				if i == option:
					child.parse_bbcode("[color=yellow][center][shake rate=10 level=10]Exit[/shake][/center][/color]")
