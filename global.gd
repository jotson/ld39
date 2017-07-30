extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var camera = get_node("/root/game/camera")
onready var player = get_node("/root/game/plane")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	randomize()
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