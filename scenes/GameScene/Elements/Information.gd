extends Control

func _on_close_button_pressed():
	GameState.closeInfo.emit()