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


func revive():
	dead = false
	get_node("killTimer").start()
	var pos = G.get_player().get_pos() + Vector2(rand_range(1, 2), 0).rotated(rand_range(-PI/4, PI/4)) * G.get_screen_width()
	set_pos(pos)
	show()

	if G.tutorial:
		get_node("tutorialAnimation").play("tutorial")
	else:
		print("stop")
		get_node("tutorialAnimation").stop_all()
		get_node("instructions").hide()


func kill():
	dead = true
	hide()


func go_away():
	queue_free()


func collision_detected(body):
	if dead:
		return
		
	if body == G.get_player():
		G.get_player().add_gas()
		kill()


func start_animation():
	get_node("wobbleAnimation").play("default")
