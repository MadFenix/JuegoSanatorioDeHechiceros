extends Node

signal nextTurn()

# Señales para las zonas
## Señal para cambiar el estado de la zona
signal zoneChanged()

## Señales para añadir magos y pociones
signal addWizard()
signal addPotion()

var currentLevel : String

var currentZone : int

var currentTurn = 1
var miningLevel = 1
var explorationLevel = 1
var mysticismLevel = 1

func incrementTurn():
	currentTurn += 1

func passToNextTurn():
	incrementTurn()
	nextTurn.emit()
