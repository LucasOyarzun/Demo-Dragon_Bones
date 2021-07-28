extends Control


enum {Play, Credits, Exit}
var option = Play
var title = true
onready var Main = $MainMenu
onready var Title = $TitleScreen
var blockinput= false
onready var options= $MainMenu/Panel/VBoxContainer2/VBoxContainer

func _ready() -> void:
	$ColorRect.color = 00000000
	$Volumen.play("Subir")
	$Musica.play()
	
	Main.visible=false
	Title.visible=true
	Title.get_node("CenterContainer/AnimationPlayer").play("parpadeo")
	updatelabel()

func _input(event):
	if blockinput:
		return
	if title:
		if event.is_action_pressed("jump"):
			blockinput=true 
			title=false
			$AnimationPlayer.play("Flashaso")
			yield($AnimationPlayer,"animation_finished")
			blockinput=false
	else:
		if event.is_action_pressed("ui_up"):
			option=(option-1)%3
			$AudioStreamPlayer.play()
			updatelabel()
		if event.is_action_pressed("ui_down"):
			option=(option+1)%3
			$AudioStreamPlayer.play()
			updatelabel()
		if event.is_action_pressed("jump"):
			$AnimationPlayer.play("Fade_out")
			

func updatelabel():
	for i in 3:
		var child = options.get_child(i)
		match i:
			Play:
				child.parse_bbcode("[center]Play[/center]")
				if i == option:
					child.parse_bbcode("[color=yellow][center][shake rate=10 level=10]Play[/shake][/center][/color]")
			Credits:
				child.parse_bbcode("[center]Credits[/center]")
				if i == option:
					child.parse_bbcode("[color=yellow][center][shake rate=10 level=10]Credits[/shake][/center][/color]")
			Exit:
				child.parse_bbcode("[center]Exit[/center]")
				if i == option:
					child.parse_bbcode("[color=yellow][center][shake rate=10 level=10]Exit[/shake][/center][/color]")
func start():
	get_tree().change_scene("res://Scenes/Intro_scene.tscn")
	
func play_credits():
	get_tree().change_scene("res://Scenes/Creditos.tscn")
func exitgame():
	get_tree().quit()



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade_out":
		match option:
				Play:
					start()
				Credits:
					play_credits()
				Exit:
					exitgame()
