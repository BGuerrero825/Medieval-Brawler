extends Node2D

var camera_offset_strength := 0.2

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	# move camera based on mouse distance from player
	transform.origin = (get_global_mouse_position() - get_parent().get_global_transform().get_origin()) * camera_offset_strength
