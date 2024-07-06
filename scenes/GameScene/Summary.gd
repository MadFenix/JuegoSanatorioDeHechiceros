extends Control


func _ready():
	GameState.nextTurn.connect(nextTurn)
	setTurnLabel(str(GameState.currentTurn))
	if GameState.currentLevel != "Map":
		%PassTurn.visible = false
	GameState.typeMagicChanged.connect(typeMagicChange)

func nextTurn():
	setTurnLabel(str(GameState.currentTurn))

func typeMagicChange(magicType):
	if magicType == 'Adivination':
		$MarginContainer/HBoxContainer/MageAdivination/AnimatedSprite2D.play("default")
	if magicType == 'Thaumaturgy':
		$MarginContainer2/HBoxContainer/MageThaumaturgy/AnimatedSprite2D.play("default")
	if magicType == 'Evocation':
		$MarginContainer3/HBoxContainer/MageEvocation/AnimatedSprite2D.play("default")
	$MarginContainer/HBoxContainer/AMQuantity.text = "x" + str(GameState.adivinationMages)
	$MarginContainer2/HBoxContainer/TMQuantity.text = "x" + str(GameState.thaumaturgyMages)
	$MarginContainer3/HBoxContainer/EMQuantity.text = "x" + str(GameState.evocationMages)
	await get_tree().create_timer(5).timeout
	if magicType == 'Adivination':
		$MarginContainer/HBoxContainer/MageAdivination/AnimatedSprite2D.stop()
	if magicType == 'Thaumaturgy':
		$MarginContainer2/HBoxContainer/MageThaumaturgy/AnimatedSprite2D.stop()
	if magicType == 'Evocation':
		$MarginContainer3/HBoxContainer/MageEvocation/AnimatedSprite2D.stop()
	

func setTurnLabel(turn):
	$MarginContainer5/VBoxContainer/CurrentTurn.text = turn + " / 13"

func _on_pass_turn_pressed():
	GameState.passToNextTurn()
