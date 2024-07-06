extends Control


func _ready():
	GameState.nextTurn.connect(nextTurn)
	setTurnLabel(str(GameState.currentTurn))
	if GameState.currentLevel != "Map":
		%PassTurn.visible = false

func nextTurn():
	setTurnLabel(str(GameState.currentTurn))

func setTurnLabel(turn):
	$MarginContainer5/VBoxContainer/CurrentTurn.text = turn + " / 13"

func _on_pass_turn_pressed():
	GameState.passToNextTurn()
