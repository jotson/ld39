extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var Cloud = load("res://cloud.tscn")
var cloudPool = Array()
var MAX_CLOUDS = 500

var Gas = load("res://gas.tscn")
var gasPool = Array()
var MAX_GAS = 100

var elapsed = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	
	set_process_input(true)
	for i in range(1,MAX_CLOUDS):
		create_cloud(true)
		
	for i in range(1,10):
		create_gas()
		
	G.get_player().connect("update_fuel", self, "update_fuel_handler")

	get_node("tutorialAnimation").play("tutorial")


func _process(delta):
	elapsed += delta
	
	# Processing input here instead of _input() because
	# _input is only called when the input changes so
	# it works okay for keyboard repeat but doesn't work
	# right when you're just holding a gamepad axis or button
	if G.state == 'playing':
		#if Input.is_action_pressed("up"):
		#	G.get_player().go_up()
		#if Input.is_action_pressed("down"):
		#	G.get_player().go_down()
		if Input.is_action_pressed("up"):
			G.get_player().go_up()
		else:
			G.get_player().coast()

	get_node("instructions").set_pos(G.get_player().get_pos() + Vector2(-100, 40))
	
	move_camera()


func update_fuel_handler(fuel):
	if G.state != 'playing':
		return
		
	if fuel > 100:
		fuel = 100
	if fuel <= 0:
		fuel = 0
		gameover()
		
	var fill = get_node("ui/fuel-bar/fuel-fill-bar")
	fill.set_scale(Vector2(fuel/100,1))
	
	var label = get_node("ui/distance-label")
	label.set_text(str(round(G.total_distance)))
	

func gameover():
	G.state = 'gameover'
	get_node("ui/gameover").show()
	
	
func move_camera():
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
	var found = false
	
	for c in cloudPool:
		if c.dead == true:
			c.revive()
			found = true
			break
			
	if !found && cloudPool.size() < MAX_CLOUDS:
		var c = Cloud.instance()
		add_child(c)
		cloudPool.append(c)
		if override:
			var pos = c.get_pos()
			pos.x = rand_range(G.get_player().get_pos().x - G.get_screen_width() * 2, G.get_player().get_pos().x + G.get_screen_width() * 2)
			pos.y = rand_range(G.get_player().get_pos().y - G.get_screen_height() * 2, G.get_player().get_pos().y + G.get_screen_height() * 2)
			c.set_pos(pos)


func create_gas():
	if G.state == 'playing':
		var found = false
		
		for g in gasPool:
			if g.dead == true:
				g.revive()
				found = true
				break
				
		if !found && gasPool.size() < MAX_GAS:
			var g = Gas.instance()
			add_child(g)
			gasPool.append(g)


func quit_game():
	OS.set_window_fullscreen(false)
	get_tree().quit()


func continue_game():
	G.state = 'playing'
	G.get_player().add_gas(G.get_player().MAX_FUEL)
	get_node("ui/gameover").hide()