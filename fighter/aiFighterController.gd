extends Node2D

@onready var fighter = get_parent()
@onready var player = Global.player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func get_orientation_target():
	return player.position
	
# standard behavior is to follow player	
func get_input_vector():
	var input_vector = Vector2.ZERO
	if self.global_position.distance_to(player.global_position) > 50:
		input_vector = player.global_position - global_position
	return input_vector.normalized()
	
func get_input():
	var input = fighter.INPUT.NONE
	if(Input.is_action_just_pressed("left_mouse")):
		input = fighter.INPUT.LPRESS	
	elif(Input.is_action_just_released("left_mouse")):
		input = fighter.INPUT.LRELEASE
	elif(Input.is_action_pressed("right_mouse")):
		input = fighter.INPUT.RPRESS
	return input 
	
func isPlayer():
	return false