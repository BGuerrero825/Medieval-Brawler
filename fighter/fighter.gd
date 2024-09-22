extends CharacterBody2D

enum INPUT{NONE, LPRESS, LRELEASE, RPRESS, RRELEASE} # player actions
enum STATE{IDLE, WINDUP, LIGHT, PARRY} # state

#movement constants
@export var MAX_SPEED := 100.0
@export var ACCELERATION := 500.0
@export var FRICTION := 400.0
@export var ROTATION_SPEED = 0.25

# global vars
var movement_allowed = true
var input_vector := Vector2(0,0)
var counter := 0.0
var rotation_dir := 0
var state = STATE.IDLE
var queuedState := STATE.IDLE

@onready var animator = $AnimationPlayer
@onready var bcon = Global.beatController

func _ready():
	if $controller.isPlayer():
		Global.setPlayer(self)
	animator.play("idle")
	
func _process(delta):
	# rotate player based on mouse location
	orientationProcessing()
	# determine velocity based on 4 directional user inputs
	movementProcessing(delta)
	# processes user input / state transitions
	stateProcessing()
	# move player
	set_velocity(velocity)
	move_and_slide()
	if bcon.inBeatWindow && state == STATE.IDLE:
		updateState()


func orientationProcessing():
	var target_rotation = position.angle_to_point($controller.get_orientation_target())
	# interpolate a new angle between current rotation and mouse position, limited by a max rotation speed
	var new_rotation = lerp_angle($pivot.rotation, target_rotation, ROTATION_SPEED)
	# set pivot rotation, add TAU to cancel negative values, then modulate down
	$pivot.rotation = fmod(TAU + new_rotation, TAU)
	
	
func movementProcessing(delta):
	#set input vector based on input strength from x axis (a/d) and y axis (w/s)
	input_vector = $controller.get_input_vector()
	if movement_allowed:
		if input_vector != Vector2.ZERO:
	#		if walking:
	#			input_vector = input_vector/2
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


# processes user input / state transitions
func stateProcessing():
	var input = $controller.get_input()
	# STATE TRANSITION LOGIC
	# IDLE
	if state == STATE.IDLE:
		if input == INPUT.LPRESS:
			queueState(STATE.WINDUP) 
	# WINDUP
	elif state == STATE.WINDUP:
		if input == INPUT.LRELEASE:
			queueState(STATE.LIGHT)
	# LIGHT
	elif state == STATE.LIGHT:
		pass
	#
	else:
		state = STATE.IDLE
		animator.play()
		animator.queue("idle")
	

func queueState(newState: STATE):
	queuedState = newState
		

func updateState():
	if (queuedState == STATE.WINDUP):
		state = STATE.WINDUP
		animator.play("RESET")
		animator.play("windup")
		#velocity = velocity * 0.9
	elif (queuedState == STATE.LIGHT):
		state = STATE.LIGHT
		animator.play("RESET")
		animator.play("light")
	queuedState = STATE.IDLE


func debug_output():
	#print("\n", self.get_name())
	#print("pivot: ", $pivot.rotation)
	pass
	
