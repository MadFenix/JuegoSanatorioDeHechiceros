extends Node2D


func _on_timer_timeout() -> void:
	$Zone.state = randi_range(0, 2)
