extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var state = 'playing'
var tutorial = true

# Total distance flown in pixels
var total_distance = 0.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	randomize()
	
	# Center window
	var ss = OS.get_screen_size(0)
	var ws = OS.get_window_size()
	OS.set_window_position(Vector2(ss.x/2 - ws.x/2, ss.y/2 - ws.y/1.33))
	
	set_process(true)


func start_playing():
	total_distance = 0.0
	state = 'playing'
	tutorial = true
	
	
func _process(delta):
	pass
	
func get_screen_width():
	var size = get_viewport().get_rect().size
	return size.x

func get_screen_height():
	var size = get_viewport().get_rect().size
	return size.y

func get_camera():
	return get_node("/root/game/camera")
	
func get_player():
	return get_node("/root/game/player")