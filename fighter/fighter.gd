extends CharacterBody2D

enum INPUT{NONE, LPRESS, LRELEASE, RPRESS, RRELEASE} # player actions
enum STATE{IDLE, WINDUP, LIGHT, PARRY} # state

var bcon = null # beatController

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
var state = IDLE
var queuedAction := ""

@onready var animator = $AnimationPlayer

func _ready():
	if $controller.isPlayer():
		Global.setPlayer(self)
	animator.play("idle")
	bcon = Global.beatController
	
func _process(delta):
	# rotate player based on mouse location
	orientation_processing()
	# determine velocity based on 4 directional user inputs
	movement_processing(delta)
	# processs user combat actions
	action_processing()
	# move player
	set_velocity(velocity)
	move_and_slide()
	# velocity = velocity
	#print out debug every half second
	counter += delta
	if(counter > 0.5):
		debug_output()
		counter = 0


func orientation_processing():
	var target_rotation = position.angle_to_point($controller.get_orientation_target())
	# interpolate a new angle between current rotation and mouse position, limited by a max rotation speed
	var new_rotation = lerp_angle($pivot.rotation, target_rotation, ROTATION_SPEED)
	# set pivot rotation, add TAU to cancel negative values, then modulate down
	$pivot.rotation = fmod(TAU + new_rotation, TAU)
	
	
func movement_processing(delta):
	#set input vector based on input strength from x axis (a/d) and y axis (w/s)
	input_vector = $controller.get_input_vector()
	if movement_allowed:
		if input_vector != Vector2.ZERO:
	#		if walking:
	#			input_vector = input_vector/2
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

# performs actions based on inputs
func action_processing():
	var input = $controller.get_input()
	# IDLE
	if state == STATE.IDLE:
		if(input == INPUT.LPRESS):
			queueAction("windup") #change this to be enum
	# WINDUP
	elif state == STATE.WINDUP:
		if(input == INPUT.LRELEASE):
			queueAction("light")

 #################################################### START HERHE


	elif(action == "release"):
		queueAction("light")
		#animator.play("light")
	elif(action == "parry"):
		pass
		#animator.play("parry")
		#velocity = velocity * 0.9
	else:
		animator.play()
		animator.queue("idle")
	
func queueAction(action: String):
	queuedAction = action
		
func executeAction():
	if (queuedAction == "windup"):
		animator.play("RESET")
		animator.play("windup")
		velocity = velocity * 0.9
	elif (queuedAction == "release"):
		animator.play("RESET")
		animator.play("light")
	queuedAction = ""
		

func debug_output():
	#print("\n", self.get_name())
	#print("pivot: ", $pivot.rotation)
	pass
	
