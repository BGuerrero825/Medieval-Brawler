extends Node2D

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = Global.player
	

func get_orientation_target():
	return player.position
	
# standard behavior is to follow player	
func get_input_vector():
	var input_vector = Vector2.ZERO
	if self.global_position.distance_to(player.global_position) > 50:
		input_vector = player.global_position - global_position
	return input_vector.normalized()
	
func get_action_input():
	var action
	if(Input.is_action_pressed("left_mouse")):
		action = "ready"
	elif(Input.is_action_just_released("left_mouse")):
		action = "parry"
	elif(Input.is_action_pressed("right_mouse")):
		action = "swing"
	else:
		action = "idle"
	return action
	
