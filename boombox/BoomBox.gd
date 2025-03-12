extends Node2D

# !!! BoomBox must be placed as the first node in the scene tree !!!
# this is so dependent nodes can reference it on their "_ready()" call

const CORE_BPM = 160.0
const BEAT_WINDOW = .25 # as a percentage of the beatLength time (ex .375sec * .25 = .09 sec before & after beat)  
const ACTION_LAG = .15 # as a percentage of beatLength

var timeOnBeat := 0.0
var bpm := CORE_BPM
var pendingAction := false 

var beatLength := 60.0 / bpm 
var actionLag := beatLength * ACTION_LAG
var beatCount := 0
var inBeatWindow := false
var onBeatFrame := false
var onActionFrame := false

# HihatDown: Down beat ||| Openhat: "sizzle" ||| HihatUp: Up beat ||| Kick: self ||| SnareBase: "punch" ||| SnareFlare: pizazz
@onready var musicTracks: Array[AudioStreamPlayer2D] = [$HihatDown, $Openhat, $SnareBase]#, $Kick]

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.setBoomBox(self)
	for track in musicTracks:
		track.play()
	beatCount = 1
	syncMusicWithBpm()


func _physics_process(delta):
	onBeatFrame = false
	onActionFrame = false
	timeOnBeat += delta
	# on beat frame
	if timeOnBeat > beatLength:
		onBeatFrame = true
		updateBeat()
		syncMusicWithBpm()
		pendingAction = true
	if pendingAction and timeOnBeat > actionLag:
		onActionFrame = true
		pendingAction = false
	# beginning of beat window
	if !inBeatWindow and (timeOnBeat >= beatLength - beatLength * BEAT_WINDOW):
		inBeatWindow = true
		#print("beatwindow start! %.0fms EARLY (-%.0f%%)" % [(beatLength - timeOnBeat) * 1000, (1 - (timeOnBeat / beatLength)) * 100])
	# end of beat window
	elif inBeatWindow and (timeOnBeat < beatLength - beatLength * BEAT_WINDOW) and (timeOnBeat >= beatLength * BEAT_WINDOW):
		inBeatWindow = false
		#print("beatwindow end! %.0fms LATE (%.0f%%)" % [timeOnBeat * 1000, (timeOnBeat / beatLength) * 100])
	

func updateBeat():
	timeOnBeat -= beatLength # set timeOnBeat to time past beatLength that just occurred
	beatLength = 60.0 / bpm
	actionLag = beatLength * ACTION_LAG
	# print("Beat #%d" % beatCount)
	beatCount += 1 


# call this only on the beat frame, otherwise it will result in desync
func syncMusicWithBpm():
	var newScale = bpm / CORE_BPM # new pitch scale = new BPM / original BPM (160). Ex: 120 / 160 = 0.75
	for track in musicTracks:
		track.pitch_scale = newScale
	if beatCount % 4 == 0:
		#print("new pitch: %.02f" % musicTracks[0].pitch_scale)
		for track in musicTracks:
			track.seek(0.0)


func queueBpmChange(newBpm: int):
	bpm = newBpm
	print("New BPM: %d,  beatLength: %.03f" % [bpm, 60.0/bpm])
