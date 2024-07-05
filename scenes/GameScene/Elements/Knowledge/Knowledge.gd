extends Control

signal levelup()
signal progress_add()
signal progress_change()

@export_enum ("Mining", "Exploration", "Mysticism") var knowledge_type = null:
	set(valor):
		knowledge_type = clamp(valor,0,2)
		label_refresh()
	get:
		return knowledge_type

@export var turns_needed_to_levelup : Array[int]

@export var pause: bool = true

@export var progress: float = 0 :
	set(valor):
		progress = clamp(valor,0,turns_needed_to_levelup[level_knowledge - 1])
		if progress >= turns_needed_to_levelup[level_knowledge - 1] && turns_needed_to_levelup.size() > level_knowledge:
			level_knowledge = level_knowledge + 1
			levelup.emit()
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

var dic_knowledge = [
	"Mining",
	"Exploration",
	"Mysticism"
]


func _ready() -> void:
	if !knowledge_type:
		knowledge_type = 0
	levelup.connect(level_change)
	progress_change.connect(progress_refresh)
	GameState.nextTurn.connect(progress_knowledge)

func label_refresh():
	$VBoxContainer/HBoxContainer/Label.text = dic_knowledge[knowledge_type]

func progress_refresh():
	$VBoxContainer/ProgressBar.value = progress / turns_needed_to_levelup[level_knowledge - 1] * 100

func progress_knowledge():
	if !pause:
		progress += 1 * multi

func multiplicador():
	$VBoxContainer/HBoxContainer/Label2.text = "Multi x " + str(multi)

func level_change():
	$VBoxContainer/HBoxContainer/Label_Nivel.text = str(level_knowledge)
	if turns_needed_to_levelup.size() > level_knowledge:
		$VBoxContainer/HBoxContainer/Label_Proximo_Nivel.text = str(level_knowledge + 1)
	else:
		$VBoxContainer/HBoxContainer/Label_Proximo_Nivel.text = str(level_knowledge)
