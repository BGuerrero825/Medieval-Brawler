# input processing control for player, attached to "controller" node
extends Node2D


@onready var fighter = get_parent()

func _ready():
	
	pass

func get_orientation_target():
	return get_global_mouse_position()
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return input_vector.normalized()
	
func get_input():
	var input = fighter.IN.NONE 
	if(Input.is_action_just_pressed("attack1")):
		input = fighter.IN.ATTACK1
		print("pressed attack1")
	elif(Input.is_action_just_released("attack1")):
		input = fighter.IN.ATTACK1_R
	elif(Input.is_action_just_released("attack2")):
		input = fighter.IN.ATTACK2
	elif(Input.is_action_pressed("defend")):
		input = fighter.IN.DEFEND
	elif(Input.is_action_just_released("defend")):
		input = fighter.IN.DEFEND
	return input 

func isPlayer():
	return true
	
