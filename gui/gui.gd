extends CanvasLayer 

var bb = null

# Called when the node enters the scene tree for the first time.
func _ready():
	bb = Global.boomBox
	$Label.text = str(bb.bpm)
	connectSlider()

func _physics_process(_delta):
	# execute beat triggered actions
	if bb.onBeatFrame:
		syncWithBpm()

func syncWithBpm():
	var playbackSpeed = 1.0 / bb.beatLength
	$AnimationPlayer.play("beat_fade", -1, playbackSpeed)

func connectSlider():
	var slider = get_node("HSlider")
	slider.value_changed.connect(_on_h_slider_value_changed)

func _on_h_slider_value_changed(value:float):
	var newBpm = value + bb.CORE_BPM
	$Label.text = str(newBpm)
	bb.setBpm(newBpm as int)
