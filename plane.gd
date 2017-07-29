extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var MAX_SPEED = 200
export var TURN_SPEED = 2

var velocity = Vector2(MAX_SPEED, 0)
var turn_speed = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)


func _process(delta):
	var p = get_pos()
	var r = get_rot()
	
	# Rotate the sprite
	set_rot(r + turn_speed * delta)
	turn_speed = turn_speed * 0.85
	
	# Limit rotation
	#if get_rot() > PI/2 - 0.1:
	#	set_rot(PI/2 - 0.1)
	#if get_rot() < -PI/2 + 0.1:
	#	set_rot(-PI/2 + 0.1)
		
	# Rotate the velocity vectory
	velocity = Vector2(MAX_SPEED, 0).rotated(get_rot())
	
	move(velocity * delta)


# Called from main game input handler
func go_up():
	turn_speed = TURN_SPEED

func go_down():
	turn_speed = -TURN_SPEED
	