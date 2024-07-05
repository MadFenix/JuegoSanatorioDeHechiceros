extends Control


func _ready():
	GameState.nextTurn.connect(nextTurn)

func nextTurn():
	$MarginContainer5/VBoxContainer/CurrentTurn.text = str(GameState.currentTurn) + " / 13"


func _on_pass_turn_pressed():
	GameState.passToNextTurn()
