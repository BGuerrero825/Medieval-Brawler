extends CharacterBody2D


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

@onready var animator = $AnimationPlayer

func _ready():
	animator.play("idle")
	Global.setPlayer(self)
	
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
	
# performs actions based on "just_pressed" inputs
func action_processing():
	var action = $controller.get_action_input()
	if(action == "ready"):
		animator.play("ready")
		velocity = velocity * 0.9
	elif(action == "swing"):
		animator.play("swing")
	elif(action == "parry"):
		animator.play("parry")
		velocity = velocity * 0.9
	else:
		animator.play()
		animator.queue("idle")
	
		
func debug_output():
	#print("\n", self.get_name())
	#print("pivot: ", $pivot.rotation)
	pass
	
