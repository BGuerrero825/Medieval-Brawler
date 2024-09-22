# input processing control for player, attached to "controller" node
extends Node2D

var fighter = null

func _ready():
	fighter = get_parent()

func get_orientation_target():
	return get_global_mouse_position()
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input_vector.normalized()
	
func get_input():
	var input = fighter.INPUT.NONE
	if(Input.is_action_pressed("left_mouse")):
		input = fighter.INPUT.LPRESS	
	elif(Input.is_action_just_released("left_mouse")):
		input = fighter.INPUT.LRELEASE
	elif(Input.is_action_pressed("right_mouse")):
		input = fighter.INPUT.RPRESS
	return input 

func isPlayer():
	return true
	
