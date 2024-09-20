extends Node

const CORE_BPM = 160

var player = null
var beatMarker = null
var boomBox = null
var beatController = null

var time := 0.0
var bpm := 160.0
var beatCadence := 60.0 / bpm 
var beatCount := 0 

func setPlayer(newPlayer):
	player = newPlayer

func setBeatController(newBeatController):
	beatController = newBeatController

func setBoomBox(newBoomBox):
	boomBox = newBoomBox 

func _process(delta):
	# update global beat and dependent systems when enough time elapses
	time += delta
	if time > beatCadence:
		time -= beatCadence
		beatCount += 1 
		beatController.update()
		print(beatCount)

func setBpm(newBpm: float):
	bpm = newBpm 
	beatCadence = 60.0 / bpm
	print("beat Cadence changed to: ", beatCadence)