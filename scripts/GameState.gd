extends Node

signal nextTurn()

signal openInfo()
signal closeInfo()

# Señales para los conocimiento
signal levelupKnowledge()

# Señales para las zonas
## Señal para cambiar el estado de la zona
signal zoneChanged()
signal zoneCured()

## Señales para añadir magos y pociones
signal addWizard()
signal addPotion()

# Señales para los tipos de magia
## Señal para cambiar el nivel de un tipo de magia
signal typeMagicChanged(magicType)

var currentLevel : String

var currentZone : int = 0

var currentTurn = 1
var maxTurn = 15
var miningLevel = 1
var explorationLevel = 1
var mysticismLevel = 1

var adivinationLevel = 1
var evocationLevel = 1
var thaumaturgyLevel = 1

var adivinationMages = 2
var evocationMages = 2
var thaumaturgyMages = 2

var currentAdivinationMages = 2
var currentEvocationMages = 2
var currentThaumaturgyMages = 2

var firstViewToBase = true

var language = 'es'

func incrementTurn():
	currentTurn += 1
	currentAdivinationMages = adivinationMages
	currentEvocationMages = evocationMages
	currentThaumaturgyMages = thaumaturgyMages

func passToNextTurn():
	incrementTurn()
	nextTurn.emit()
