extends Node

signal nextTurn(turn)

var currentTurn = 1

func incrementTurn():
	currentTurn += 1

func passToNextTurn():
	incrementTurn()
	nextTurn.emit(currentTurn)
