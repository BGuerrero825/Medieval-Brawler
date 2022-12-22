extends Node

var player
var time := 0.0
var beat = 0

func set_player(new_player):
	player = new_player

func _process(delta):
	time += delta
	var old_beat = beat
	beat = int(floor(time * 3))
	if beat != old_beat:
		print(beat)
