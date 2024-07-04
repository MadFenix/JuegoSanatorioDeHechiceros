extends Control

"""
Zona:

    - Tiene que haber un sistema de cantidad de magos por tipo necesarios para curar la zona.
    - Sistema para saber si la zona está enferma, curada o sin afectaciones.
    - Si está enferma, tiene que haber un sistema para, al arrastrar magos o pociones, llenar los requerimientos y definir si se cura o no en ese turno la zona.
    - Tiene que tener un sistema de diálogo para cuando la zona se enferma y también para cuando se cura.

"""

@onready var gameState : Node = get_node("/root/GameState")

@export var zoneName : String 
@export var state : String = "sana"  # Estado inicial por defecto
# Magos necesarios por tipo para curar la zona
@export var adivination_required: int = 0
@export var thaumaturgy_required : int = 0
@export var evocation_required : int = 0

var states = ["sana", "enferma", "curada"]

# Pociones y magos asignados a la zona
var adivination_assigned : int = 0
var thaumaturgy_assigned : int = 0
var evocation_assigned : int = 0
var current_potions : int = 0

var dialogue : String # Diálogo que se mostrará al terminar el turno
var last_state : String = ""

func _ready():
    # Conectar señales de GameState
    gameState.connect("nextTurn", Callable(self, "nextTurn"))
    gameState.connect("addWizard", Callable(self, "assign_wizards"))
    gameState.connect("addPotion", Callable(self, "assign_potions"))

    # Por defecto, si no se ha asignado un estado válido, se asigna "sana"
    if state not in states:
        state = "sana"
    
    update_dialogue() # Actualizar el diálogo inicial

func check_zone_state() -> String:
    return state

# Asignar magos a la zona por tipo
func assign_wizard(type: String) -> void:
    if type == "adivinacion":
        adivination_assigned += 1
    elif type == "taumaturgia":
        thaumaturgy_assigned += 1
    elif type == "evocacion":
        evocation_assigned += 1

func assign_potions(amount: int) -> void:
    current_potions += amount

func check_cure() -> void:
    last_state = state
    
    # Si hay suficientes magos asignados, la zona se cura
    if thaumaturgy_assigned >= thaumaturgy_required and adivination_assigned >= adivination_required and evocation_assigned >= evocation_required:
        state = "curada"

    if last_state == state and state != "enferma":
        state = "sana"
    

func update_dialogue() -> void:

    if state == "enferma":
        
        var needed_wizards = calculate_needed_wizards()
        var thaumaturgy_needed = needed_wizards[0]
        var adivination_needed = needed_wizards[1]
        var evocation_needed = needed_wizards[2]

        dialogue = "La zona está enferma. Necesita " + str(thaumaturgy_needed) + " taumaturgos, " + str(adivination_needed) + " adivinos y " + str(evocation_needed) + " evocadores para curarse."

    elif state == "curada":

        dialogue = "La zona ha sido curada. ¡Felicidades!"



func calculate_needed_wizards() -> Array:
    
    # Devuelve la cantidad de magos necesarios por tipo para curar la zona
    # Formato de retorno: Taumaturgos, Adivinos, Evocadores

    var thaumaturgy_needed = max(0, thaumaturgy_required - thaumaturgy_assigned)
    var adivination_needed = max(0, adivination_required - adivination_assigned)
    var evocation_needed = max(0, evocation_required - evocation_assigned)

    return [thaumaturgy_needed, adivination_needed, evocation_needed]
    

func nextTurn() -> void:
    check_cure()  # Verificar si la zona se cura
    update_dialogue()  # Actualizar diálogo
    gameState.emit_signal("zoneChanged", state, dialogue)  # Emitir señal de cambio de estado

func changeStateToIll() -> void:
    # Cambia el estado de la zona a enferma
    state = "enferma"