extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.beatController.setBeatMarker(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pulse():
	var playbackSpeed = 1.0 / Global.beatCadence
	self.play("beat_fade", -1, playbackSpeed)
