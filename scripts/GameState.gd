extends Node

signal nextTurn(turn)

# Señales para las zonas
## Señal para cambiar el estado de la zona
signal zoneChanged(state, dialogue)

## Señales para añadir magos y pociones
signal addWizard(type)
signal addPotion(amount)

var currentTurn = 1

func incrementTurn():
	currentTurn += 1

func passToNextTurn():
	incrementTurn()
	nextTurn.emit(currentTurn)
