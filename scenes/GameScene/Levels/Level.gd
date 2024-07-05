extends Node

signal level_won
signal level_lost

func _on_lose_button_pressed():
	emit_signal("level_lost")

func _on_win_button_pressed():
	emit_signal("level_won")

func _input(event):
	if GameState.currentZone && GameState.currentZone.state == 1 && event.is_action_pressed('click'):
		GameState.currentZone.showDialog()
