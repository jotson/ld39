extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var cloud = load("res://cloud.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	set_process_input(true)
	for i in range(1,20):
		create_cloud(true)


func _process(delta):
	pass

func _input(event):
	if Input.is_action_pressed("up"):
		G.get_player().go_up()
		
	if Input.is_action_pressed("down"):
		G.get_player().go_down()


func create_cloud(override = false):
	for i in range(1,5):
		var c = cloud.instance()
		add_child(c)
		if override:
			var pos = c.get_pos()
			pos.x = rand_range(G.get_camera().get_pos().x - G.get_screen_width()/2, G.get_camera().get_pos().x + G.get_screen_width()/2)
			c.set_pos(pos)
