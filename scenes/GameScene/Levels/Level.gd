extends Node

signal level_won
signal level_lost
signal level_won_finally

func _ready():
	GameState.openInfo.connect(openInfoFunctionality)
	GameState.closeInfo.connect(closeInfoFunctionality)
	if GameState.firstViewToBase:
		GameState.firstViewToBase = false
		GameState.openInfo.emit()

func openInfoFunctionality():
	$Information.visible = true

func closeInfoFunctionality():
	$Information.visible = false

func _on_lose_button_pressed():
	emit_signal("level_lost")

func _on_win_button_pressed():
	emit_signal("level_won")

func _on_summary_run_credits():
	level_lost.emit()

func _on_summary_win_run_credits():
	level_won_finally.emit()
