class_name TypeMagicClass
extends Control

signal levelup()

@export_enum ("Adivination", "Thaumaturgy", "Evocation") var magic_type = null:
	set(valor):
		magic_type = clamp(valor,0,2)
		label_refresh()
	get:
		return magic_type

@export var mining_needed_to_levelup : Array[int]
@export var exploration_needed_to_levelup : Array[int]
@export var mysticism_needed_to_levelup : Array[int]
@export var sourcerers_by_levelup : Array[int]

@export var pause: bool = true

@export var level_magic: int = 1:
	set(valor):
		level_magic = valor
		if dic_magic[magic_type] == 'Adivination':
			GameState.adivinationLevel = level_magic
			GameState.adivinationMages = sourcerers_by_levelup[level_magic - 1]
		if dic_magic[magic_type] == 'Thaumaturgy':
			GameState.thaumaturgyLevel = level_magic
			GameState.thaumaturgyMages = sourcerers_by_levelup[level_magic - 1]
		if dic_magic[magic_type] == 'Evocation':
			GameState.evocationLevel = level_magic
			GameState.evocationMages = sourcerers_by_levelup[level_magic - 1]
		level_change()
		save_state()
	get:
		return level_magic

var dic_magic = [
	"Adivination",
	"Thaumaturgy",
	"Evocation"
]

var dialog = "Loading..."
var confirmationDialog : Node

func _ready() -> void:
	confirmationDialog = $ConfirmationDialog
	if !magic_type:
		magic_type = 0
	levelup.connect(level_change)
	
	# Cargar el estado guardado si existe
	if StateManager.has_magic_state(dic_magic[magic_type]):
		var saved_state = StateManager.load_magic_state(dic_magic[magic_type])
		restore_state(saved_state)

func getDialog():
	var isMiningAccepted = GameState.miningLevel >= mining_needed_to_levelup[level_magic - 1]
	var isExplorationAccepted = GameState.explorationLevel >= exploration_needed_to_levelup[level_magic - 1]
	var isMysticismAccepted = GameState.mysticismLevel >= mysticism_needed_to_levelup[level_magic - 1]
	if isMiningAccepted && isExplorationAccepted && isMysticismAccepted:
		dialog = "Do you want to level up?"
	else:
		if GameState.language == 'en':
			dialog = "You do not meet the requirements to level up.\nMining: " + str(mining_needed_to_levelup[level_magic - 1]) + "\nExploration: " + str(exploration_needed_to_levelup[level_magic - 1]) + "\nMysticism: " + str(mysticism_needed_to_levelup[level_magic - 1])
		if GameState.language == 'es':
			dialog = "No cumples los requisitos para subir de nivel.\nMinería: " + str(mining_needed_to_levelup[level_magic - 1]) + "\nExploración: " + str(exploration_needed_to_levelup[level_magic - 1]) + "\nMisticismo: " + str(mysticism_needed_to_levelup[level_magic - 1])
		if GameState.language == 'ca':
			dialog = "No cumpleixes els requisits per pujar de nivell.\nMineria: " + str(mining_needed_to_levelup[level_magic - 1]) + "\nExploració: " + str(exploration_needed_to_levelup[level_magic - 1]) + "\nMisticisme: " + str(mysticism_needed_to_levelup[level_magic - 1])
	confirmationDialog.title = getType()
	confirmationDialog.dialog_text = dialog
	confirmationDialog.popup_centered()

func getType() -> String:
	return dic_magic[magic_type]

func label_refresh():
	$VBoxContainer/HBoxContainer/Label.text = getType()

func level_change():
	$VBoxContainer/HBoxContainer/Label_Nivel.text = str(level_magic)

func _on_texture_button_pressed():
	getDialog()

func _on_confirmation_dialog_canceled():
	confirmationDialog.hide()

func _on_confirmation_dialog_confirmed():
	var isMiningAccepted = GameState.miningLevel >= mining_needed_to_levelup[level_magic - 1]
	var isExplorationAccepted = GameState.explorationLevel >= exploration_needed_to_levelup[level_magic - 1]
	var isMysticismAccepted = GameState.mysticismLevel >= mysticism_needed_to_levelup[level_magic - 1]
	if isMiningAccepted && isExplorationAccepted && isMysticismAccepted:
		level_magic += 1
		if dic_magic[magic_type] == 'Adivination':
			GameState.currentAdivinationMages += sourcerers_by_levelup[level_magic - 1] - sourcerers_by_levelup[level_magic - 2]
		if dic_magic[magic_type] == 'Thaumaturgy':
			GameState.currentThaumaturgyMages += sourcerers_by_levelup[level_magic - 1] - sourcerers_by_levelup[level_magic - 2]
		if dic_magic[magic_type] == 'Evocation':
			GameState.currentEvocationMages += sourcerers_by_levelup[level_magic - 1] - sourcerers_by_levelup[level_magic - 2]
		GameState.typeMagicChanged.emit(dic_magic[magic_type])
	confirmationDialog.hide()


# Método para guardar el estado del conocimiento
func save_state():
	var state_data = {
		"level_magic": level_magic
	}
	StateManager.save_magic_state(dic_magic[magic_type], state_data)

# Método para restaurar el estado del conocimiento
func restore_state(state_data: Dictionary):
	level_magic = state_data["level_magic"]
