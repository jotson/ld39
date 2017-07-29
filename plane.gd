extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var speed = 100

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)


func _process(delta):
	var p = get_pos()
	p.x = p.x + speed * delta
	set_pos(p)