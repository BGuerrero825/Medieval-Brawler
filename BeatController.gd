extends Node2D

var player = null
var beatMarker = null
var boomBox = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# must be placed higher in node tree so that it loads before its dependent nodes
	Global.setBeatController(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setBeatMarker(newBeatMarker):
	beatMarker = newBeatMarker

func setBoomBox(newBoomBox):
	boomBox = newBoomBox

# called by global on new beat, triggers beat dependent actions
func update():
	print("update beatController")
	if beatMarker:
		beatMarker.pulse()
	if Global.boomBox:
		print("boomBox path")
		Global.boomBox.sync()

func _on_h_slider_value_changed(value:float):
	print("value changed to: ", value)
	Global.setBpm(Global.CORE_BPM + value)
