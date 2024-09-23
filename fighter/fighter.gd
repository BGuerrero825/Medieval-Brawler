extends CharacterBody2D

enum INPUT {NONE, LPRESS, LRELEASE, RPRESS, RRELEASE} # player inputs 
enum STATE {IDLE, WINDUP, LIGHT, PARRY} # state

#movement constants
@export var MAX_SPEED := 100.0
@export var ACCELERATION := 500.0
@export var FRICTION := 400.0
@export var ROTATION_SPEED := 0.25
@export var QUEUE_TIMEOUT := 0.5

# global vars
var movement_allowed = true
var input_vector := Vector2(0,0)
var counter := 0.0
var rotation_dir := 0
var state := STATE.IDLE
var desiredState := STATE.IDLE
var queuedState := STATE.IDLE
var updatingState := false
var queueTimer := 0.0

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
	# move player
	set_velocity(velocity)
	move_and_slide()

	# processes user input / state transitions
	inputProcessing()

	#TODO : better input -> queue/immediate exec -> queue drop -> state change print statements to debug loop
	if queuedState != STATE.IDLE:
		queueTimer += delta

	if queueTimer > QUEUE_TIMEOUT:
		clearQueue()

	if desiredState != STATE.IDLE && !bcon.inBeatWindow:
		queueState(desiredState)

	if bcon.inBeatWindow and queuedState != STATE.IDLE and !updatingState:
		print(">>>>> UPDATED STATE FROM QUEUE :: ", queuedState)
		desiredState = queuedState
		updateState()

	if ((bcon.inBeatWindow and desiredState != state) and !updatingState):
		print(">>>>> CURRENT :: ", state, "  |  DESIRED :: ", desiredState)
		updateState()
	if not bcon.inBeatWindow:
		updatingState = false


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
func inputProcessing():
	var input = $controller.get_input()
	# STATE TRANSITION LOGIC
	desiredState = STATE.IDLE 	# assume character wants to do nothing next
	# IDLE
	if state == STATE.IDLE:
		if input == INPUT.LPRESS:
			desiredState = STATE.WINDUP 
	# WINDUP
	elif state == STATE.WINDUP:
		desiredState = STATE.LIGHT
	# LIGHT
	elif state == STATE.LIGHT:
		if input == INPUT.LPRESS:
			print("got lpress while swinging")
			desiredState = STATE.WINDUP 
		

# change state of character based on queuedState
func updateState():
	if desiredState == state:
		return
	updatingState = true
	if (desiredState == STATE.IDLE):
		state = STATE.IDLE
		animator.play("RESET")
		animator.play("idle")
	elif (desiredState == STATE.WINDUP):
		state = STATE.WINDUP
		animator.play("RESET")
		animator.play("windup")
		#velocity = velocity * 0.9
	elif (desiredState == STATE.LIGHT):
		state = STATE.LIGHT
		animator.play("RESET")
		animator.play("light")

	print(">>>>> CHANGED TO :: ", state)
	

func queueState(newState: STATE):
	queueTimer = 0.0
	if newState == queuedState:
		return
	queuedState = newState
	print(">>>>> QUEUED :: ", queuedState)


func clearQueue():
	queuedState = STATE.IDLE
	queueTimer = 0
	print("queue CLEARED!@!!!!")

func debug_output():
	#print("\n", self.get_name())
	#print("pivot: ", $pivot.rotation)
	pass
	
