extends Area2D

var speed = 200

onready var sprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("default")
	$Timer.connect("timeout", self, "dissapear")
	connect("body_entered", self, "on_body_entered") # self porque la funcion está en mi mismo
	
func on_body_entered(body: Node):
	if body.is_in_group("player"): # Si choca con el jugador
		var player: Player = body
		var knockdir = player.transform.origin - transform.origin # Knockback
		player.knockback(knockdir)
		player.take_damage(1)
		sprite.play("explosion")
		$Timer.start()
	if body.is_in_group("map"):    # Si choca con el mapa
		sprite.play("explosion")
		$Timer.start()
func _physics_process(delta):
	position +=Vector2(cos(rotation), sin(rotation)) * speed * delta
	
func dissapear():
	queue_free() # Me destruyo a mi mismo
	
