extends Node2D

signal nivel_alcanzado()
signal progress_add()
signal progress_change()

@export_enum ("Mineria", "Exploracion", "Misticismo") var magic_type = 0:
	set(valor):
		magic_type = clamp(valor,0,2)
	get:
		return magic_type



@export var pause: bool = false

@export var progress: float = 0 :
	set(valor):
		progress = clamp(valor,0,100)
		if progress >= 100:
			nivel_alcanzado.emit()
			level_magic = level_magic + 1
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

@export var level_magic: int = 0:
	set(valor):
		level_magic = valor
		level_change()
	get:
		return level_magic

var dic_magic = {
	0: "Mineria",
	1: "Exploracion",
	2: "Misticismo"
}


func _ready() -> void:
	progress_change.connect(progress_refresh)
	progress_add.connect(conocimiento)

	
func progress_refresh():
	$VBoxContainer/ProgressBar.value = progress
	
func conocimiento():
	progress += 1 * multi


func multiplicador():
	$VBoxContainer/HBoxContainer/Label2.text = "Multi x " + str(multi)

func level_change():
	$VBoxContainer/HBoxContainer/Label_Nivel.text = str(level_magic)
	$VBoxContainer/HBoxContainer/Label_Proximo_Nivel.text = str(level_magic + 1)
