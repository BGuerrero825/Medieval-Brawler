# input processing control for player, attached to "controller" node
extends Node2D

var action

func _ready():
	Global.setPlayer(self)

func get_orientation_target():
	return get_global_mouse_position()
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input_vector.normalized()
	
func get_action_input():
	action = "idle"
	if(Input.is_action_pressed("left_mouse")):
		action = "ready"
	elif(Input.is_action_just_released("left_mouse")):
		action = "swing"
	elif(Input.is_action_pressed("right_mouse")):
		action = "parry"
	return action
	
