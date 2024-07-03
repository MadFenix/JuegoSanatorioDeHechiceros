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
@export var required_wizards : Dictionary = {}  # Cantidad de magos necesarios por tipo

var states = ["sana", "enferma", "curada"]

# Recursos actuales asignados a la zona
var current_wizards : Dictionary = {}
var current_potions : int = 0

var dialogue : String

func _ready():
    # Conectar señal de cambio de turno
    gameState.connect("nextTurn", Callable(self, "nextTurn"))
    gameState.connect("addWizard", Callable(self, "assign_wizards"))
    gameState.connect("addPotion", Callable(self, "assign_potions"))

    if state not in states:
        state = "sana"
    
    update_dialogue() # Actualizar el diálogo inicial

func check_zone_state() -> String:
    return state

# Asignar magos a la zona por tipo
func assign_wizard(type: String):
    if current_wizards.has(type):
        current_wizards[type] += 1
    else:
        current_wizards[type] = 1

func assign_potions(amount: int):
    current_potions += amount

func check_cure():
    if state == "enferma":
        var needed_wizards = calculate_needed_wizards()
        needed_wizards -= current_potions  # Reducir magos necesarios por la cantidad de pociones
        current_potions = 0  # Resetear pociones después de usarlas

        if needed_wizards <= 0:
            state = "curada"
        else:
            state = "enferma"

func update_dialogue():
    if state == "enferma":
        dialogue = "La zona está enferma. Necesita " + str(calculate_needed_wizards()) + " magos para curarla."
    elif state == "curada":
        dialogue = "La zona ha sido curada. ¡Felicidades!"
    elif state == "sana":
        dialogue = "La zona está sana, no se necesita hacer nada."


func calculate_needed_wizards() -> int:
    var needed = 0
    for type in required_wizards.keys():
        needed += max(0, required_wizards[type] - current_wizards.get(type, 0))
    return needed
    

func nextTurn():
    check_cure()  # Verificar si la zona se cura
    update_dialogue()  # Actualizar diálogo
    gameState.emit_signal("zoneChanged", state, dialogue)  # Emitir señal de cambio de estado

