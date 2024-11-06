extends Node

var player = null
var beatController = null
var entities = []

func _process(_delta):
	pass

func setPlayer(newPlayer):
	player = newPlayer

func setBeatController(newBeatController):
	beatController = newBeatController

func addEntity(newEntity):
	entities.append(newEntity)

func removeEntity(oldEntity):
	entities.erase(oldEntity)