extends CharacterBody2D

enum IN {NONE, ATTACK1, ATTACK1_R, ATTACK2, DEFEND, DEFEND_R} # controller inputs 
enum STATE {IDLE, WINDUP, SWEEP, THRUST, PARRY} # character state

# movement constants
@export var MAX_SPEED := 100.0
@export var ACCELERATION := 500.0
@export var FRICTION := 400.0
@export var ROTATION_SPEED := 0.25
@export var QUEUE_TIMEOUT := 0.5

# @export var controller: Node2D

# global vars
var movable = true
var input := 0
var inputVector := Vector2(0,0)
var counter := 0.0
var rotationDir := 0
var state := STATE.IDLE
var desiredState := STATE.IDLE
var queuedState := STATE.IDLE
var updatingState := false
var queueTimer := 0.0


@onready var animator = $AnimationPlayer
@onready var bb = Global.boomBox
@onready var controller = $controller

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
	processState()
	processOrientation() # rotate player based on mouse location
	processMovement(delta) # determine velocity based on 4 directional user inputs
	move_and_slide()
	

# change state of character based on desiredState 
# TODO: move to a proper state machine
func processState():
	input = $controller.get_input()
	var entry = false
	
	if input == IN.NONE and !bb.onBeatFrame:
		return

	if bb.onBeatFrame:
		if state != queuedState:
			animator.play("RESET")
		state = queuedState
		entry = true

	match state:
		STATE.IDLE:
			# _idle()
			if entry:
				animator.queue("idle")
			if input == IN.ATTACK1:
				state = STATE.WINDUP
				if bb.inBeatWindow:
					print("IN BEAT WINDOW!!!")
					queuedState = STATE.WINDUP
				else: 
					queuedState = STATE.IDLE
				animator.play("RESET")
				animator.queue("windup")

		STATE.WINDUP:
			# _windup()
			if bb.onBeatFrame:
				queuedState = STATE.IDLE
			if input == IN.ATTACK1:
				queuedState = STATE.SWEEP
				print("queued state is: %d" % queuedState)
			if input == IN.ATTACK2:
				queuedState = STATE.THRUST
			
		STATE.SWEEP:
			# _sweep()		
			if entry:
				playAnim("sweep")
				queuedState = STATE.IDLE

		STATE.THRUST:
			# _thrust()
			if entry:
				animator.play("RESET")
				animator.play("thrust")
				queuedState = STATE.IDLE

		_:
			print("Unknown state %d" % state)
			pass

	# early / late debug print
	debugBeatTiming()

	#debugOutput()


func processOrientation():
	var target_rotation = position.angle_to_point($controller.get_orientation_target())
	# interpolate a new angle between current rotation and mouse position, limited by a max rotation speed
	var new_rotation = lerp_angle($pivot.rotation, target_rotation, ROTATION_SPEED)
	# set pivot rotation, add TAU to cancel negative values, then modulate down
	$pivot.rotation = fmod(TAU + new_rotation, TAU)
	
	
func processMovement(delta):
	#set input vector based on input strength from x axis (a/d) and y axis (w/s)
	inputVector = $controller.get_input_vector()
	if movable:
		if inputVector != Vector2.ZERO:
	#		if walking:
	#			inputVector = inputVector/2
			velocity = velocity.move_toward(inputVector * MAX_SPEED, ACCELERATION * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)


func playAnim(animName: String = "RESET") -> void:
	animator.play("RESET")
	animator.advance(0.0)
	animator.is_playing()
	animator.play(animName)


func debugOutput():
	if bb.onBeatFrame:
		print("\n", self.get_name())
		print("pivot: ", $pivot.rotation)
	

func debugBeatTiming():
	if input == IN.ATTACK1:
		if bb.timeOnBeat < bb.beatLength / 2:
			print("%.0fms LATE (%.0f%%)" % [bb.timeOnBeat * 1000, (bb.timeOnBeat / bb.beatLength) * 100])
		else:
			print("%.0fms EARLY (-%.0f%%)" % [(bb.beatLength - bb.timeOnBeat) * 1000, (1 - (bb.timeOnBeat / bb.beatLength)) * 100])
