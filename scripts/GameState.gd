extends Node

signal nextTurn()

# Señales para las zonas
## Señal para cambiar el estado de la zona
signal zoneChanged()

## Señales para añadir magos y pociones
signal addWizard()
signal addPotion()

# Señales para los tipos de magia
## Señal para cambiar el nivel de un tipo de magia
signal typeMagicChanged(magicType)

var currentLevel : String

var currentZone : int = 0

var currentTurn = 1
var miningLevel = 1
var explorationLevel = 1
var mysticismLevel = 1

var adivinationLevel = 1
var evocationLevel = 1
var thaumaturgyLevel = 1

var adivinationMages = 2
var evocationMages = 2
var thaumaturgyMages = 2

func incrementTurn():
	currentTurn += 1

func passToNextTurn():
	incrementTurn()
	nextTurn.emit()
