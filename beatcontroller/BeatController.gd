extends Node2D

const CORE_BPM = 160
const BEAT_WINDOW = .25 # as a percentage of the beatSeconds time (ex .375sec * .25 before & after beat)  

var gui = null
var boomBox = null

var timeOnBeat := 0.0
var bpm := 160.0
var beatSeconds := 60.0 / bpm 
var beatCount := 0 
var inBeatWindow := false


# Called when the node enters the scene tree for the first time.
func _ready():
	# must be placed higher in node tree so that it loads before its dependent nodes
	Global.setBeatController(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# update global beat and dependent systems when enough time elapses
	timeOnBeat += delta
	# enter pre-beat window
	if !inBeatWindow and beatSeconds - timeOnBeat < beatSeconds * BEAT_WINDOW:
		inBeatWindow = true
	# exit post-beat window
	elif inBeatWindow and timeOnBeat > beatSeconds * BEAT_WINDOW:
		inBeatWindow = false
	
	# execute beat triggered actions
	if timeOnBeat > beatSeconds:
		# reset timeOnBeat to time past beatSeconds that just occurred
		timeOnBeat -= beatSeconds
		# update beatSeconds now if game bpm has changed
		updateBeat()
		updateGui()
		#print(beatCount)


# triggers beat dependent actions
func updateGui():
	if gui:
		gui.pulse()
	if boomBox:
		boomBox.sync()


func updateBeat():
	beatSeconds = 60.0 / bpm
	beatCount += 1 
	inBeatWindow = true


func setGui(newGui):
	gui = newGui 
	var slider = gui.get_node("HSlider")
	slider.value_changed.connect(_on_h_slider_value_changed)


func setBoomBox(newBoomBox):
	boomBox = newBoomBox


func setBpm(newBpm: float):
	bpm = newBpm



func _on_h_slider_value_changed(value:float):
	setBpm(CORE_BPM + value)
	#bcon.setBpm(bcon.CORE_BPM + value)
