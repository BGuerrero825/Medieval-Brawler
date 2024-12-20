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
	updateState()


# change state of character based on desiredState 
# TODO: move to a proper state machine
func updateState():
	var input = $controller.get_input()

	if bb.onBeatFrame:
		state = queuedState
		if state == STATE.WINDUP:
			queuedState = STATE.IDLE
		if state == STATE.LIGHT:
			animator.play("RESET")
			animator.play("light")
			queuedState = STATE.IDLE

	if state == STATE.IDLE:
		animator.play("RESET")
		animator.play("idle")
		if input == INPUT.LPRESS:
			state = STATE.WINDUP
			if bb.inBeatWindow:
				print("IN BEAT WINDOW!!!")
				queuedState = STATE.WINDUP
			else: 
				queuedState = STATE.IDLE
			animator.play("RESET")
			animator.play("windup")

	elif state == STATE.WINDUP:
		if input == INPUT.LPRESS:
			queuedState = STATE.LIGHT
			print("queued state is: %d" % queuedState)

	elif state == STATE.LIGHT:
		pass

		
	# early / late debug print
	if input == INPUT.LPRESS:
		if bb.timeOnBeat < bb.beatLength / 2:
			print("%.0fms LATE (+%.0f%%)" % [bb.timeOnBeat * 1000, (bb.timeOnBeat / bb.beatLength) * 100])
		else:
			print("%.0fms EARLY (-%.0f%%)" % [(bb.beatLength - bb.timeOnBeat) * 1000, (1 - (bb.timeOnBeat / bb.beatLength)) * 100])


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
	
