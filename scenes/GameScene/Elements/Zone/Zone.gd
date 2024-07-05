class_name ZoneClass
extends Node2D

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
@export var turn_to_ill : int = 0
@export var zoneNumber : int = 0

var states = ["sana", "enferma", "curada"]
var statesColors = [
	Color(0, 0, 0, 0),
	Color(0.4, 0.2, 0.6, 0.5),
	Color(0, 0.5, 0, 0.5)
]

# Pociones y magos asignados a la zona
var adivination_assigned : int = 0
var thaumaturgy_assigned : int = 0
var evocation_assigned : int = 0
var current_potions : int = 0

var dialogue : String # Diálogo que se mostrará al terminar el turno
var last_state : int = 0

var popup_open

func _ready():
	# Conectar señales de GameState
	GameState.nextTurn.connect(nextTurn)    
	load_form()
	
	# Cargar el estado guardado si existe
	if StateManager.has_zone_state(zoneName):
		var saved_state = StateManager.load_zone_state(zoneName)
		restore_state(saved_state)
	
	nextTurn()

func load_form():
	$Area2D/Polygon2D.polygon = $Area2D/CollisionPolygon2D.polygon

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
	if thaumaturgy_assigned >= thaumaturgy_required and adivination_assigned >= adivination_required and evocation_assigned >= evocation_required:
		state = 2 # curada
		GameState.emit_signal("zoneChanged")
	if last_state == state and state != 1:
		state = 0 # sana
		GameState.emit_signal("zoneChanged")

	if GameState.currentTurn == turn_to_ill:
		state = 1

func update_dialogue() -> void:
	if states[state] == "enferma":
		var thaumaturgy_needed = max(0, thaumaturgy_required - thaumaturgy_assigned)
		var adivination_needed = max(0, adivination_required - adivination_assigned)
		var evocation_needed = max(0, evocation_required - evocation_assigned)
		dialogue = "La zona está enferma. Necesita " + str(thaumaturgy_needed) + " taumaturgos, " + str(adivination_needed) + " adivinos y " + str(evocation_needed) + " evocadores más para curarse."
	elif states[state] == "curada":
		dialogue = "La zona ha sido curada. ¡Felicidades!"

func nextTurn() -> void:
	set_state()
	update_dialogue()
	# Guardar el estado de la zona al final del turno
	save_state()

func changeStateToIll() -> void:
	state = 1

func showDialog():
	%ZoneDialog.title = zoneName
	%ZoneDialog.dialog_text = dialogue
	%ZoneDialog.popup_centered()
	popup_open = %ZoneDialog

func _on_area_2d_mouse_entered():
	GameState.currentZone = zoneNumber

# Método para guardar el estado de la zona
func save_state():
	var state_data = {
		"state": state,
		"adivination_assigned": adivination_assigned,
		"thaumaturgy_assigned": thaumaturgy_assigned,
		"evocation_assigned": evocation_assigned,
		"current_potions": current_potions,
		"dialogue": dialogue,
		"last_state": last_state
	}
	StateManager.save_zone_state(zoneName, state_data)

# Método para restaurar el estado de la zona
func restore_state(state_data: Dictionary):
	state = state_data["state"]
	adivination_assigned = state_data["adivination_assigned"]
	thaumaturgy_assigned = state_data["thaumaturgy_assigned"]
	evocation_assigned = state_data["evocation_assigned"]
	current_potions = state_data["current_potions"]
	dialogue = state_data["dialogue"]
	last_state = state_data["last_state"]
	load_state()
