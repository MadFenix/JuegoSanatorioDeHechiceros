extends Control

signal runCredits
signal winRunCredits

func _ready():
	GameState.nextTurn.connect(nextTurn)
	setTurnLabel(str(GameState.currentTurn))
	if GameState.currentLevel != "Map":
		%PassTurn.visible = false
	GameState.typeMagicChanged.connect(typeMagicChange)
	GameState.zoneChanged.connect(typeMagicChange)
	GameState.zoneCured.connect(hideBackToBase)
	typeMagicChange()

func nextTurn():
	setTurnLabel(str(GameState.currentTurn))
	showBackToBase()

func hideBackToBase():
	$MarginContainer7/GoToMapBtn.visible = false

func showBackToBase():
	$MarginContainer7/GoToMapBtn.visible = true

func typeMagicChange(magicType = ""):
	if magicType == 'Adivination':
		$MarginContainer/HBoxContainer/MageAdivination/AnimatedSprite2D.play("default")
	if magicType == 'Thaumaturgy':
		$MarginContainer2/HBoxContainer/MageThaumaturgy/AnimatedSprite2D.play("default")
	if magicType == 'Evocation':
		$MarginContainer3/HBoxContainer/MageEvocation/AnimatedSprite2D.play("default")
	$MarginContainer/HBoxContainer/AMQuantity.text = "x" + str(GameState.currentAdivinationMages)
	$MarginContainer2/HBoxContainer/TMQuantity.text = "x" + str(GameState.currentThaumaturgyMages)
	$MarginContainer3/HBoxContainer/EMQuantity.text = "x" + str(GameState.currentEvocationMages)
	await get_tree().create_timer(5).timeout
	if magicType == 'Adivination':
		$MarginContainer/HBoxContainer/MageAdivination/AnimatedSprite2D.stop()
	if magicType == 'Thaumaturgy':
		$MarginContainer2/HBoxContainer/MageThaumaturgy/AnimatedSprite2D.stop()
	if magicType == 'Evocation':
		$MarginContainer3/HBoxContainer/MageEvocation/AnimatedSprite2D.stop()
	

func setTurnLabel(turn):
	$MarginContainer5/VBoxContainer/CurrentTurn.text = turn + " / " + str(GameState.maxTurn)

func _on_pass_turn_pressed():
	if GameState.currentTurn < GameState.maxTurn:
		GameState.passToNextTurn()
	if GameState.currentTurn < GameState.maxTurn && StateManager.allZonesAreCured():
		Dialogic.timeline_ended.connect(_on_timeline_ended_won)
		Dialogic.start("won")
	if GameState.currentTurn == GameState.maxTurn:
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		Dialogic.start("zoneIll10")

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	runCredits.emit()

func _on_timeline_ended_won():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended_won)
	winRunCredits.emit()

func _on_info_btn_pressed():
	GameState.openInfo.emit()
