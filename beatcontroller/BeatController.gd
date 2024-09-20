extends Node2D

const CORE_BPM = 160

var gui = null
var boomBox = null

var time := 0.0
var bpm := 160.0
var beatCadence := 60.0 / bpm 
var beatCount := 0 

# Called when the node enters the scene tree for the first time.
func _ready():
	# must be placed higher in node tree so that it loads before its dependent nodes
	Global.setBeatController(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# update global beat and dependent systems when enough time elapses
	time += delta
	if time > beatCadence:
		time -= beatCadence
		beatCount += 1 
		self.update()
		print(beatCount)

# triggers beat dependent actions
func update():
	if gui:
		gui.pulse()
	if boomBox:
		boomBox.sync()

func setGui(newGui):
	gui = newGui 
	var slider = gui.get_node("HSlider")
	slider.value_changed.connect(_on_h_slider_value_changed)

func setBoomBox(newBoomBox):
	boomBox = newBoomBox

func setBpm(newBpm: float):
	bpm = newBpm
	beatCadence = 60.0 / newBpm

func _on_h_slider_value_changed(value:float):
	setBpm(CORE_BPM + value)
	#bcon.setBpm(bcon.CORE_BPM + value)