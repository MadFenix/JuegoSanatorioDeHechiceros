extends Node

signal nextTurn()

var currentTurn = 1
var miningLevel = 1
var explorationLevel = 1
var mysticismLevel = 1

func incrementTurn():
	currentTurn += 1

func passToNextTurn():
	incrementTurn()
	nextTurn.emit()
