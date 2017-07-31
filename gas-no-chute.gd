extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var life = 0
var target
var dir

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	if G.get_camera() == null:
		queue_free()
		return
		
	target = G.get_camera().get_pos();
	target.x -= G.get_screen_width()/2
	target.y -= G.get_screen_height()/2
	dir = target - get_pos()
	dir = dir.normalized() * 1000
	set_process(true)
	
func _process(delta):
	life = life + delta
	if life > 0.25:
		queue_free()
		
	set_pos(get_pos() + dir * delta)