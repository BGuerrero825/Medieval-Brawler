extends CanvasLayer 

var bcon

# Called when the node enters the scene tree for the first time.
func _ready():
	bcon = Global.beatController
	bcon.setGui(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pulse():
	var playbackSpeed = 1.0 / bcon.beatCadence
	$AnimationPlayer.play("beat_fade", -1, playbackSpeed)