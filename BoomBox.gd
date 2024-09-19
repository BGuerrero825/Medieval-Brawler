extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$HihatDown.play()
	$Openhat.play()
	$Kick.play()
	$SnareBase.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
