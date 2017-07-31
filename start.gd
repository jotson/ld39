extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var Cloud = load("res://cloud.tscn")
var cloudPool = Array()
var MAX_CLOUDS = 200

var player_position = Vector2(0,0)

var action = 'nothing'

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	reset_player(G.get_player())
	
	for i in range(1,MAX_CLOUDS):
		create_cloud()
		
	set_fixed_process(true)
	set_process_input(true)
	
	get_node("CanvasLayer/playButton").connect("mouse_enter", self, 'play_click')
	get_node("CanvasLayer/playButton").connect("mouse_exit", self, 'play_click')
	get_node("CanvasLayer/quitButton").connect("mouse_enter", self, 'play_click')
	get_node("CanvasLayer/quitButton").connect("mouse_exit", self, 'play_click')


func play_click():
	Sfx.play("click")

func play_beep():
	Sfx.play("beep")


func _input(event):
	if Input.is_action_pressed("fullscreen"):
		if OS.is_window_fullscreen():
			OS.set_window_fullscreen(false)
		else:
			OS.set_current_screen(0)
			OS.set_window_fullscreen(true)

	if Input.is_action_pressed("up"):
		play_game()
	
	
func _fixed_process(delta):
	create_cloud()
	
	G.get_player().fuel = 100
	
	if action == 'up':
		G.get_player().go_up()
	else:
		G.get_player().coast()
	

func play_game():
	G.start_playing()
	play_beep()
	get_tree().change_scene("res://cutscene.tscn")


func quit_game():
	get_tree().quit()


func create_cloud():
	var found = false
	
	for c in cloudPool:
		if c.dead == true:
			c.revive()
			found = true
			var pos = c.get_pos()
			pos.x = rand_range(G.get_screen_width() * 1.5, G.get_screen_width() * 2)
			pos.y = rand_range(-G.get_screen_height() * 0.25, G.get_screen_height() * 1.25)
			c.set_pos(pos)
			break
			
	if !found && cloudPool.size() < MAX_CLOUDS:
		var c = Cloud.instance()
		add_child(c)
		cloudPool.append(c)
		var pos = c.get_pos()
		pos.x = rand_range(-G.get_screen_width() * 2, G.get_screen_width() * 2)
		pos.y = rand_range(-G.get_screen_height() * 2, G.get_screen_height() * 2)
		c.set_pos(pos)


func choose_ai_action():
	var random = rand_range(0,100)
	if random < 50:
		action = 'up'
	else:
		action = 'nothing'
		


# Reposition player when it exits playpen
func reset_player(body):
	G.get_player().set_pos(Vector2(-25, rand_range(0, G.get_screen_height())))
