extends Node2D

var hp_player = 3
var offset_lifes = 80
var lifes_list                      # Lista de vidas
export (PackedScene) var sprite_hp  # Sprite de vidas


func _ready():
	create_lifes()

func create_lifes():
	for i in hp_player: # Creamos las vidas iniciales
		var newLife = sprite_hp.instance()
		get_tree().get_nodes_in_group("gui")[0].add_child(newLife)
		newLife.global_position.x +=offset_lifes * i
		lifes_list.append(newLife)
		
func add_life():
	hp_player -= 1         # Disminuye la vida
	lifes_list[hp_player].queue_free() # Quita la lutima vida
	
func lose_life():
	hp_player += 1         # Aumentamos la vida
	var newLife = sprite_hp.instance()
	get_tree().get_nodes_in_group("gui")[0].add_child(newLife)
	newLife.global_position.x += offset_lifes * (hp_player - 1)
	lifes_list[hp_player-1].append(newLife)
	
		
