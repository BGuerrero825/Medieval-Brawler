extends Node2D

# !!! BoomBox must be placed as the first node in the scene tree !!!
# this is so dependent nodes can reference it on their "_ready()" call

const CORE_BPM = 160
const BEAT_WINDOW = .25 # as a percentage of the beatLength time (ex .375sec * .25 before & after beat)  

var gui = null
var boomBox = null

var timeOnBeat := 0.0
var bpm := 160.0
var beatLength := 60.0 / bpm 
var beatCount := 0 
var inBeatWindow := false
var onBeatFrame := false

# HihatDown: Down beat ||| Openhat: "sizzle" ||| HihatUp: Up beat ||| Kick: self ||| SnareBase: "punch" ||| SnareFlare: pizazz
@onready var musicTracks = [$HihatDown, $Openhat, $SnareBase]#, $Kick]

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.setBoomBox(self)
	for track in musicTracks:
		track.play()
	pass 

func _physics_process(delta):
	timeOnBeat += delta
	# on beat frame
	if timeOnBeat > beatLength:
		hitBeat()
		syncWithBpm()
	else:
		onBeatFrame = false
	# beginning of beat window
	if !inBeatWindow and beatLength - timeOnBeat < beatLength * BEAT_WINDOW:
		inBeatWindow = true
	# end of beat window
	elif inBeatWindow and timeOnBeat > beatLength * BEAT_WINDOW:
		inBeatWindow = false
	

func hitBeat():
	onBeatFrame = true
	# reset timeOnBeat to time past beatLength that just occurred
	beatLength = 60.0 / bpm
	beatCount += 1 
	print(get_node(get_path()).name, " received onBeatFrame (", beatCount, ")")


func syncWithBpm():
	var newScale = bpm / CORE_BPM 	# new pitch scale = new BPM / original BPM (160). Ex: 120 / 160 = 0.75
	timeOnBeat -= beatLength
	for track in musicTracks:
		track.pitch_scale = newScale


func setBpm(newBpm: int):
	bpm = newBpm
