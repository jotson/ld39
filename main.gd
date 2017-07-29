extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var cloud = load("res://cloud.tscn")

onready var plane = get_node("plane")
onready var cam1 = get_node("camera1")


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	set_process_input(true)
	cam1.set_pos(plane.get_pos())
	for i in range(1,20):
		create_cloud(true)


func _process(delta):
	cam1.set_pos(plane.get_pos())


func _input(event):
	if Input.is_action_pressed("up"):
		print("up")
		
	if Input.is_action_pressed("down"):
		print("down")


func create_cloud(override = false):
	var make_cloud = override
	
	if rand_range(1,10) < 3:
		make_cloud = true
		
	if make_cloud:
		var c = cloud.instance()
		add_child(c)
		if override:
			var pos = c.get_pos()
			pos.x = rand_range(G.get_camera().get_pos().x - G.get_screen_width()/2, G.get_camera().get_pos().x + G.get_screen_width()/2)
			c.set_pos(pos)
