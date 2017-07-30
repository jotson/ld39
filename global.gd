extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var camera = get_node("/root/game/camera")
onready var player = get_node("/root/game/player")

var state = 'playing'

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	randomize()
	
	# Center window
	var ss = OS.get_screen_size(0)
	var ws = OS.get_window_size()
	OS.set_window_position(Vector2(ss.x/2 - ws.x/2, ss.y/2 - ws.y/1.33))
	
	set_process(true)

func _process(delta):
	pass
	
func get_screen_width():
	var size = get_viewport().get_rect().size
	return size.x

func get_screen_height():
	var size = get_viewport().get_rect().size
	return size.y

func get_camera():
	return camera
	
func get_player():
	return player