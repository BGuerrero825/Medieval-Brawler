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
@onready var bb = Global.boomBox

func _ready():
	if not $controller.get_script():
		return
	if $controller.isPlayer():
		Global.setPlayer(self)
	Global.addEntity(self)
	animator.play("idle")
	
func _physics_process(delta):
	if bb.onBeatFrame:
		print(get_node(get_path()).name, " received onBeatFrame (", bb.beatCount, ")")
	if not $controller.get_script():
		return
	# rotate player based on mouse location
	orientationProcessing()
	# determine velocity based on 4 directional user inputs
	movementProcessing(delta)
	# move player
	set_velocity(velocity)
	move_and_slide()

	# processes user input / state transitions
	inputProcessing()

	if bb.inBeatWindow and queuedState != STATE.IDLE and !updatingState:
		desiredState = queuedState
		updateState()

	if ((bb.inBeatWindow and desiredState != state) and !updatingState):
		#print(">>>>> CURRENT :: ", state, "  |  DESIRED :: ", desiredState)
		updateState()
	if not bb.inBeatWindow:
		updatingState = false


# processes user input / state transitions
func inputProcessing():
	var input = $controller.get_input()
	# early / late debug print
	if input == INPUT.LPRESS:
		if bb.timeOnBeat < bb.beatLength / 2:
			print("%.0fms LATE (+%.0f%%)" % [bb.timeOnBeat * 1000, (bb.timeOnBeat / bb.beatLength) * 100])
		else:
			print("%.0fms EARLY (-%.0f%%)" % [(bb.beatLength - bb.timeOnBeat) * 1000, (1 - (bb.timeOnBeat / bb.beatLength)) * 100])
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
			#print("got lpress while swinging")
			desiredState = STATE.WINDUP 
		

# change state of character based on desiredState 
func updateState():
	if desiredState == state:
		return
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

	#print(">>>>> CHANGED TO :: ", state)


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


func debug_output():
	#print("\n", self.get_name())
	#print("pivot: ", $pivot.rotation)
	pass
	
