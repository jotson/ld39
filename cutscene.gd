extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process_input(true)
	
	var gas = get_node("gas")
	gas.set_pos(Vector2(420, 0))
	pass


func _input(event):
	if Input.is_action_pressed("up"):
		_on_Timer_timeout()


func _on_Timer_timeout():
	Sfx.stop_all()
	get_tree().change_scene("res://main.tscn")
	pass # replace with function body
