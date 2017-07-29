extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var cloud = load("res://cloud.tscn")
var cloudPool = Array()
var MAX_CLOUDS = 500
var elapsed = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	set_process_input(true)
	for i in range(1,MAX_CLOUDS):
		create_cloud(true)


func _process(delta):
	elapsed += delta
	
	# Processing input here instead of _input() because
	# _input is only called when the input changes so
	# it works okay for keyboard repeat but doesn't work
	# right when you're just holding a gamepad axis or button
	if Input.is_action_pressed("up"):
		G.get_player().go_up()
		
	if Input.is_action_pressed("down"):
		G.get_player().go_down()

	get_node("ui/fuelLabel").set_text(str(int(G.get_player().fuel)))

	# Move camera
	# The follow camera is causing some frame jank
	# so I'm adding shake to hide it
	var player = G.get_player()
	var shakeWobble = sin(elapsed*3.3) + sin(elapsed*7.7)
	var vertical_shake = player.velocity.rotated(PI/2).normalized() * shakeWobble * 8
	var leadWobble = sin(elapsed)
	var lead = player.velocity + player.velocity.normalized() * leadWobble * 5
	get_node("camera").set_pos(player.get_pos() + lead + vertical_shake)


func _input(event):
	if Input.is_action_pressed("fullscreen"):
		if OS.is_window_fullscreen():
			OS.set_window_fullscreen(false)
		else:
			OS.set_current_screen(0)
			OS.set_window_fullscreen(true)


func create_cloud(override = false):
	if cloudPool.size() < MAX_CLOUDS:
		var c = cloud.instance()
		add_child(c)
		cloudPool.append(c)
		if override:
			var pos = c.get_pos()
			pos.x = rand_range(G.get_player().get_pos().x - G.get_screen_width() * 2, G.get_player().get_pos().x + G.get_screen_width() * 2)
			pos.y = rand_range(G.get_player().get_pos().y - G.get_screen_height() * 2, G.get_player().get_pos().y + G.get_screen_height() * 2)
			c.set_pos(pos)
	else:
		for c in cloudPool:
			if c.dead == true:
				c.revive()
				break
