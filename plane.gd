extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var MAX_SPEED = 200
export(float) var TURN_SPEED = 2.0
export(float) var COAST_TURN_SPEED = 1.0
export(float) var FUEL_CONSUMPTION_RATE_PER_SECOND = 3.0
export var FUEL_REFILL = 25
export var MAX_FUEL = 100
export var fuel = 100
export(bool) var be_quiet = false

var velocity = Vector2(MAX_SPEED, 0)
var turn_speed = 0
var gas_caught = 0
var plane_voice

signal update_fuel(fuel)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	plane_voice = Sfx.play("plane")
	if be_quiet:
		Sfx.set_volume(plane_voice, 0)


func _fixed_process(delta):
	var p = get_pos()
	var r = get_rot()
	
	# Consume fuel
	fuel = fuel - FUEL_CONSUMPTION_RATE_PER_SECOND * delta
	if fuel < 0:
		fuel = 0
	emit_signal("update_fuel", fuel)
	
	# Rotate the sprite
	set_rot(r + turn_speed * delta)
	turn_speed = turn_speed * 0.85
	
	# Update propeller soound
	var pitch = PI + abs(get_rot()) + rand_range(-0.1, 0.1)
	pitch = abs(pitch / PI * 0.75)
	if fuel <= 15 and fuel > 0:
		pitch = pitch * fuel / 15
	if fuel <= 0:
		Sfx.set_volume(plane_voice, 0)
	if fuel > 0 and !be_quiet:
		Sfx.set_volume(plane_voice, 1)
	Sfx.set_pitch_scale(plane_voice, pitch)

		# Limit rotation
	#if get_rot() > PI/2 - 0.1:
	#	set_rot(PI/2 - 0.1)
	#if get_rot() < -PI/2 + 0.1:
	#	set_rot(-PI/2 + 0.1)
		
	# Rotate the velocity vectory
	velocity = Vector2(MAX_SPEED, 0).rotated(get_rot())
	
	# Track total distance flown
	if G.state == 'playing':
		G.total_distance += velocity.length() * delta
	
	move(velocity * delta)
	

# Called from main game input handler
func go_up():
	turn_speed = TURN_SPEED

func go_down():
	turn_speed = -TURN_SPEED

func coast():
	var r = get_rot()
	if r >= PI/2 || r < -PI/4:
		turn_speed = COAST_TURN_SPEED
	else:
		turn_speed = -COAST_TURN_SPEED
	
func add_gas(amount = 0):
	if amount == 0:
		amount = FUEL_REFILL
	fuel = fuel + amount
	if fuel > MAX_FUEL:
		fuel = MAX_FUEL
	emit_signal("update_fuel", fuel)

	gas_caught = gas_caught + 1
	if gas_caught >= 3:
		G.tutorial = false
