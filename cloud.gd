extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var velocity = Vector2(-rand_range(10,50), 0)
var MAX_DISTANCE = 10
var distance = rand_range(-MAX_DISTANCE, 3)
var currentCloud = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)

	# Hide all cloud sprites
	for cloud in get_children():
		cloud.hide()
	
	# Choose a random cloud sprite
	var random = rand_range(0, get_child_count()-1)
	currentCloud = get_child(random)
	currentCloud.show()
	
	# Randomly position cloud outside of camera
	var pos = G.get_player().get_pos() + Vector2(G.get_screen_width(), 0).rotated(randf() * 2 * PI)
	set_pos(pos)
	
	# Set size
	var scale = rand_range(1,2)
	set_scale(Vector2(scale, scale))
	
	# Randomly flip for variety
	if rand_range(0,100) < 50:
		currentCloud.set_flip_h(true)
		
	# Modulate color so more distance clouds blend in with the sky
	if distance < -9:
		var c = Color(0, 0.5, 1, 1)
		currentCloud.set_modulate(c)
	elif distance < -7:
		var c = Color(0.3, 0.7, 1, 1)
		currentCloud.set_modulate(c)
	elif distance < -5:
		var c = Color(0.5, 0.8, 1, 1)
		currentCloud.set_modulate(c)
	elif distance < -3:
		var c = Color(0.7, 0.9, 1, 1)
		currentCloud.set_modulate(c)
	
	# Randomly tint some clouds reddish
	if rand_range(0,100) < 10:
		var c = currentCloud.get_modulate()
		c.r = rand_range(0,1)
		currentCloud.set_modulate(c)
	
	# Move clouds close but behind plane to foreground
	if distance > -1:
		distance = 1
	
	# Speed up foreground clouds
	if distance > -2:
		velocity = velocity * 5
	if distance > 0:
		velocity = velocity * 5
		
	# Set depth
	set_z(distance)
	
	# Has face?
	if currentCloud.get_child_count() > 0:
		change_animation()

func _process(delta):
	# Move clouds
	move(velocity * delta)
	
	# Kill clouds when far from player
	var distance = get_pos().distance_to(G.get_player().get_pos())
	if distance > G.get_screen_width() * 2:
		queue_free()
		

func change_animation():
	var face = currentCloud.get_child(0)
	var anim = face.get_animation()
	var random = rand_range(0,100)
	face.stop()
	face.set_frame(0)
	if anim == "sleep":
		if random < 25:
			face.play("wake")
		else:
			face.play("sleep")
	else:
		if random < 25:
			face.play("default")
		else:
			face.play("sleep")
		