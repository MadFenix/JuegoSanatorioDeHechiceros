extends Control

signal progress_add()
signal progress_change()

@export_enum ("Mining", "Exploration", "Mysticism") var knowledge_type = null:
	set(valor):
		knowledge_type = clamp(valor,0,2)
		label_refresh()
	get:
		return knowledge_type

@export var turns_needed_to_levelup : Array[int]

@export var pause: bool = true :
	set(valor):
		pause = valor
		if pause && texture_pause_true:
			$TextureButton.texture_normal = texture_pause_true
		if !pause && texture_pause_false:
			$TextureButton.texture_normal = texture_pause_false
	get:
		return pause

@export var progress: float = 0 :
	set(valor):
		progress = clamp(valor,0,turns_needed_to_levelup[level_knowledge - 1])
		if progress >= turns_needed_to_levelup[level_knowledge - 1] && turns_needed_to_levelup.size() > level_knowledge:
			level_knowledge = level_knowledge + 1
			GameState.levelupKnowledge.emit()
			progress = 0
		if turns_needed_to_levelup.size() <= level_knowledge:
			progress = 0
		progress_change.emit()
	get:
		return progress

@export var multi: int = 1:
	set(valor):
		multi = valor
		multiplicador()
	get:
		return multi

@export var level_knowledge: int = 1:
	set(valor):
		level_knowledge = valor
		if dic_knowledge[knowledge_type] == 'Mining':
			GameState.miningLevel = level_knowledge
		if dic_knowledge[knowledge_type] == 'Exploration':
			GameState.explorationLevel = level_knowledge
		if dic_knowledge[knowledge_type] == 'Mysticism':
			GameState.mysticismLevel = level_knowledge
		level_change()
	get:
		return level_knowledge

@export var texture_pause_true : Texture2D
@export var texture_pause_false : Texture2D

var dic_knowledge = [
	"Mining",
	"Exploration",
	"Mysticism"
]

var current_turn : int = 1


func _ready() -> void:
	if !knowledge_type:
		knowledge_type = 0
	GameState.levelupKnowledge.connect(level_change)
	progress_change.connect(progress_refresh)
	GameState.nextTurn.connect(progress_knowledge)
	
	# Cargar el estado guardado si existe
	if StateManager.has_knowledge_state(dic_knowledge[knowledge_type]):
		var saved_state = StateManager.load_knowledge_state(dic_knowledge[knowledge_type])
		restore_state(saved_state)
	else:
		save_state()

func label_refresh():
	$VBoxContainer/HBoxContainer/Label.text = dic_knowledge[knowledge_type]

func progress_refresh():
	$VBoxContainer/MarginContainer/ProgressBar.value = progress / turns_needed_to_levelup[level_knowledge - 1] * 100

func progress_knowledge():
	if !pause:
		if knowledge_type == 0:
			print('test')
		progress += 1 * multi

func multiplicador():
	$VBoxContainer/HBoxContainer/Label2.text = "Multi x " + str(multi)

func level_change():
	$VBoxContainer/HBoxContainer/Label_Nivel.text = str(level_knowledge)
	if turns_needed_to_levelup.size() > level_knowledge:
		$VBoxContainer/HBoxContainer/Label_Proximo_Nivel.text = str(level_knowledge + 1)
	else:
		$VBoxContainer/HBoxContainer/Label_Proximo_Nivel.text = str(level_knowledge)

# Método para guardar el estado del conocimiento
func save_state():
	var state_data = {
		"knowledge_type": knowledge_type,
		"pause": pause,
		"progress": progress,
		"multi": multi,
		"level_knowledge": level_knowledge,
		"current_turn": current_turn
	}
	StateManager.save_knowledge_state(dic_knowledge[knowledge_type], state_data)

# Método para restaurar el estado del conocimiento
func restore_state(state_data: Dictionary):
	knowledge_type = state_data["knowledge_type"]
	pause = state_data["pause"]
	progress = state_data["progress"]
	multi = state_data["multi"]
	level_knowledge = state_data["level_knowledge"]
	current_turn = state_data["current_turn"]
	while current_turn < GameState.currentTurn:
		current_turn += 1
		if pause == false:
			progress_knowledge()
	save_state()
