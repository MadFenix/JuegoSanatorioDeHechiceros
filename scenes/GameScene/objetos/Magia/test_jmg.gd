extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Magia.level_magic = 3
	$Magia.progress = 97


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$Magia.progress_add.emit()
