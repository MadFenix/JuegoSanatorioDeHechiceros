extends Node

signal nextTurn()

# Señales para las zonas
## Señal para cambiar el estado de la zona
signal zoneChanged(state, dialogue)

## Señales para añadir magos y pociones
signal addWizard(type)
signal addPotion(amount)

var currentTurn = 1
var miningLevel = 1
var explorationLevel = 1
var mysticismLevel = 1

func incrementTurn():
	currentTurn += 1

func passToNextTurn():
	incrementTurn()
	nextTurn.emit()
