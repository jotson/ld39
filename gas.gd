extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var velocity = Vector2(0, 50)
var active = true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	
	var pos = G.get_player().get_pos() + Vector2(rand_range(1, 2), 0).rotated(rand_range(-PI/4, PI/4)) * G.get_screen_width()
	set_pos(pos)
	
	var t = get_node("startTimer")
	t.set_wait_time(rand_range(0,1))
	t.start()
	
	var t = get_node("expireTimer")
	t.set_wait_time(rand_range(5,8))
	t.start()


func _fixed_process(delta):
	move(velocity * delta)


func expire():
	active = false
	queue_free()


func go_away():
	queue_free()


func collision_detected(body):
	if active == false:
		return
		
	active = false
	
	if body == G.get_player():
		G.get_player().add_gas()
		queue_free()


func start_animation():
	get_node("AnimationPlayer").play("default")

