extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var velocity = Vector2(0, 50)
var dead = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	
	revive()
	
	var t = get_node("startTimer")
	t.set_wait_time(rand_range(0,1))
	t.start()
	

func _fixed_process(delta):
	move(velocity * delta)
	
	if get_pos().distance_to(G.get_player().get_pos()) < 200:
		get_node("AnimatedSprite").play("happy")
	else:
		get_node("AnimatedSprite").play("default")

func revive():
	dead = false
	get_node("killTimer").start()
	var pos = G.get_player().get_pos() + Vector2(rand_range(1, 2), 0).rotated(rand_range(-PI/4, PI/4)) * G.get_screen_width()
	set_pos(pos)
	get_node("AnimatedSprite").show()

	if G.tutorial:
		get_node("tutorialAnimation").play("tutorial")
	else:
		get_node("tutorialAnimation").stop_all()
		get_node("instructions").hide()


func kill():
	get_node("Particles2D").set_emitting(true)
	dead = true
	get_node("AnimatedSprite").hide()


func collision_detected(body):
	if dead:
		return
		
	if body == G.get_player():
		Sfx.play("get-gas")
		G.get_player().add_gas()
		kill()
		var NoChute = load("res://gas-no-chute.tscn")
		var t = NoChute.instance()
		t.set_pos(get_pos())
		get_node("/root/game").add_child(t)


func start_animation():
	get_node("wobbleAnimation").play("default")
