extends Node2D

"""
Zona:

	- Tiene que haber un sistema de cantidad de magos por tipo necesarios para curar la zona.
	- Sistema para saber si la zona está enferma, curada o sin afectaciones.
	- Si está enferma, tiene que haber un sistema para, al arrastrar magos o pociones, llenar los requerimientos y definir si se cura o no en ese turno la zona.
	- Tiene que tener un sistema de diálogo para cuando la zona se enferma y también para cuando se cura.

"""

@export var zoneName : String 
@export_enum ("sana", "enferma", "curada") var state = 0 : # Estado inicial por defecto
	set(valor):
		state = valor
		load_state()
	get:
		return state
# Magos necesarios por tipo para curar la zona
@export var adivination_required : int = 1
@export var thaumaturgy_required : int = 1
@export var evocation_required : int = 0
@export var form : Array[Vector2] = [
	Vector2(0, 0),
	Vector2(0, 100),
	Vector2(100, 100),
	Vector2(100, 0),
] :
	set(valor):
		form = valor
		load_form()
	get:
		return form

var states = ["sana", "enferma", "curada"]
var statesColors = [
	Color(0, 0, 0, 0),
	Color(102, 51, 153, 0.5),
	Color(0, 128, 0, 0.5)
]

# Pociones y magos asignados a la zona
var adivination_assigned : int = 0
var thaumaturgy_assigned : int = 0
var evocation_assigned : int = 0
var current_potions : int = 0

var dialogue : String # Diálogo que se mostrará al terminar el turno
var last_state : String = ""

func _ready():
	# Conectar señales de GameState
	GameState.nextTurn.connect(nextTurn)
	
	update_dialogue() # Actualizar el diálogo inicial

func load_form():
	$Area2D/CollisionPolygon2D.polygon = form
	$Area2D/Polygon2D.polygon = form

func load_state():
	$Area2D/Polygon2D.color = statesColors[state]

func check_zone_state() -> String:
	return states[state]

# Asignar magos a la zona por tipo
func assign_wizard(type: TypeMagicClass) -> void:
	GameState.addWizard.emit()
	if type.getType() == "Adivination":
		adivination_assigned += 1
	elif type.getType() == "Thaumaturgy":
		thaumaturgy_assigned += 1
	elif type.getType() == "Evocation":
		evocation_assigned += 1

func assign_potions(amount: int) -> void:
	GameState.addPotion.emit()
	current_potions += amount

func set_state() -> void:
	last_state = state
	# Si hay suficientes magos asignados, la zona se cura
	if thaumaturgy_assigned >= thaumaturgy_required and adivination_assigned >= adivination_required and evocation_assigned >= evocation_required:
		state = 2 # curada
		GameState.emit_signal("zoneChanged")  # Emitir señal de cambio de estado
	if last_state == state and state != 1: # != enferma
		state = 0 # sana
		GameState.emit_signal("zoneChanged")  # Emitir señal de cambio de estado
	

func update_dialogue() -> void:
	if states[state] == "enferma":        
		# Devuelve la cantidad de magos necesarios por tipo para curar la zona
		# Formato de retorno: Taumaturgos, Adivinos, Evocadores
		var thaumaturgy_needed = max(0, thaumaturgy_required - thaumaturgy_assigned)
		var adivination_needed = max(0, adivination_required - adivination_assigned)
		var evocation_needed = max(0, evocation_required - evocation_assigned)
		dialogue = "La zona está enferma. Necesita " + str(thaumaturgy_needed) + " taumaturgos, " + str(adivination_needed) + " adivinos y " + str(evocation_needed) + " evocadores más para curarse."
	elif states[state] == "curada":
		dialogue = "La zona ha sido curada. ¡Felicidades!"

func nextTurn() -> void:
	set_state()  # Verificar si la zona se cura
	update_dialogue()  # Actualizar diálogo

func changeStateToIll() -> void:
	# Cambia el estado de la zona a enferma
	state = 1 # "enferma"
