extends Node2D

var bcon

# Called when the node enters the scene tree for the first time.
func _ready():
	bcon = Global.beatController
	Global.beatController.setBoomBox(self)
	$HihatDown.play()
	$Openhat.play()
	# $Kick.play()
	# $SnareBase.play()
	$HihatUp.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func sync():
	var newScale = bcon.bpm / bcon.CORE_BPM 
	$HihatDown.pitch_scale = newScale
	$Openhat.pitch_scale = newScale
	$Kick.pitch_scale = newScale
	$SnareBase.pitch_scale = newScale
	$HihatUp.pitch_scale = newScale
