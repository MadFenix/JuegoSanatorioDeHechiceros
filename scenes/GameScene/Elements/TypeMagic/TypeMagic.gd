class_name TypeMagicClass
extends Node2D

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
		level_change()
	get:
		return level_magic

var dic_magic = [
	"Adivination",
	"Thaumaturgy",
	"Evocation"
]

func _ready() -> void:
	if !magic_type:
		magic_type = 0
	levelup.connect(level_change)

func getType() -> String:
	return dic_magic[magic_type]

func label_refresh():
	$VBoxContainer/Label.text = getType()

func level_change():
	$VBoxContainer/HBoxContainer/Label_Nivel.text = str(level_magic)
	$VBoxContainer/HBoxContainer/Label_Proximo_Nivel.text = str(level_magic + 1)
