extends Node

signal level_won
signal level_lost

func _on_lose_button_pressed():
	emit_signal("level_lost")

func _on_win_button_pressed():
	emit_signal("level_won")

func _input(event):
	if GameState.currentLevel == 'Map':
		var zoneName = get_node("%Zone" + str(GameState.currentZone))
		if zoneName && zoneName.state == 1 && event.is_action_pressed('click'):
			zoneName.showDialog()
