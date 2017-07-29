extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var speed = rand_range(10,50)
var MAX_DISTANCE = 10
var distance = rand_range(-MAX_DISTANCE, 3)
var currentCloud = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	
	for cloud in get_children():
		cloud.hide()
		
	var random = rand_range(0, get_child_count()-1)
	currentCloud = get_child(random)
	var x = G.get_screen_width()/2 + G.get_camera().get_pos().x + currentCloud.get_texture().get_width()/2 * 2
	var y = rand_range(G.get_camera().get_pos().y - G.get_screen_height()/2 - 20, G.get_camera().get_pos().y + G.get_screen_height()/2 + 20)
	set_pos(Vector2(x, y))
	set_z(distance)
	var scale = rand_range(1,2)
	set_scale(Vector2(scale, scale))
	
	if rand_range(0,100) < 50:
		currentCloud.set_flip_h(true)
		
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
	
	if rand_range(0,100) < 10:
		var c = currentCloud.get_modulate()
		c.r = rand_range(0,1)
		currentCloud.set_modulate(c)
	
	if distance == 0:
		distance = 1
		
	if distance > -2:
		speed = speed * 10
	if distance > 0:
		speed = speed * 10
		
	currentCloud.show()

func _process(delta):
	var p = get_pos()
	p.x = p.x - speed * delta
	set_pos(p)
	if p.x < G.get_camera().get_pos().x - G.get_screen_width()/2 - currentCloud.get_texture().get_width()/2 * 2:
		print("bye bye cloud")
		queue_free()
		