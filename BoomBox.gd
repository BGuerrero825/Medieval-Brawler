extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.setBoomBox(self)
	$HihatDown.play()
	$Openhat.play()
	$Kick.play()
	$SnareBase.play()
	$HihatUp.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func sync():
	var scale = Global.bpm / Global.CORE_BPM 
	$HihatDown.pitch_scale = scale
	$Openhat.pitch_scale = scale
	$Kick.pitch_scale = scale
	$SnareBase.pitch_scale = scale
	$HihatUp.pitch_scale = scale
