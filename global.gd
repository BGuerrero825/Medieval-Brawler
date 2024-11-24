extends Node

var player = null
var boomBox = null # BoomBox node reference
var entities = []

func _process(_delta):
	pass

func setPlayer(newPlayer):
	player = newPlayer

func setBoomBox(newBoomBox):
	boomBox = newBoomBox

func addEntity(newEntity):
	entities.append(newEntity)

func removeEntity(oldEntity):
	entities.erase(oldEntity)