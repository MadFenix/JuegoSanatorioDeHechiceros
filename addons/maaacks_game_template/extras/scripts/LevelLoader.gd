@tool
class_name LevelLoader
extends SceneLister
## Extends [SceneLister] to manage level advancement through [GameLevelLog].

signal level_load_started
signal level_loaded
signal levels_finished

## Container where the level instance will be added.
@export var level_container : Node
## Loads a level on start.
@export var auto_load : bool = true
@export_group("Debugging")
@export var force_level : int = -1

var backgroundMusicNode : Node
var backgroundMusicMap = preload("res://assets/sound/map.mp3")
var backgroundMusicBase = preload("res://assets/sound/base.mp3")

var current_level : Node

var button_sound : Node
var button_magic_sound : Node

func get_current_level_id() -> int:
	return GameLevelLog.get_current_level() if force_level == -1 else force_level

func get_level_file(level_id : int = get_current_level_id()):
	if files.is_empty():
		push_error("levels list is empty")
		return
	if level_id >= files.size():
		push_error("level_id is out of bounds of the levels list")
		level_id = files.size() - 1
	return files[level_id]

func advance_level() -> bool:
	var level_id : int = get_current_level_id()
	level_id += 1
	if level_id >= files.size():
		emit_signal("levels_finished")
		level_id = files.size() - 1
		return false
	GameLevelLog.level_reached(level_id)
	return true

func _attach_level(level_resource : Resource):
	assert(level_container != null, "level_container is null")
	var instance = level_resource.instantiate()
	level_container.call_deferred("add_child", instance)
	return instance

func _clear_current_level():
	if is_instance_valid(current_level):
		current_level.queue_free()
	current_level = null

func load_level(level_id : int = get_current_level_id()):
	_clear_current_level()
	var level_file = get_level_file(level_id)
	SceneLoader.load_scene(level_file, true)
	emit_signal("level_load_started")
	await(SceneLoader.scene_loaded)
	current_level = _attach_level(SceneLoader.get_resource())
	emit_signal("level_loaded")
	await get_tree().create_timer(1).timeout
	instanceButtonsSoundSignals()
	instanceButtonsMagicSoundSignals()

func advance_and_load_level():
	if advance_level():
		load_level()

func instanceButtonsSoundSignals():
	var buttons: Array = get_tree().get_nodes_in_group("Button")
	for inst in buttons:
		inst.pressed.connect(on_button_pressed)

func instanceButtonsMagicSoundSignals():
	var buttons: Array = get_tree().get_nodes_in_group("ButtonMagic")
	for inst in buttons:
		inst.pressed.connect(on_button_magic_pressed)

func on_button_pressed():
	button_sound.play()

func on_button_magic_pressed():
	button_magic_sound.play()

func switch_level():
	var level_id : int = get_current_level_id()
	if level_id == 0:
		level_id = 1
		GameState.currentLevel = 'Map'
		backgroundMusicNode.stream = backgroundMusicMap
	else:
		level_id = 0
		GameState.currentLevel = 'Base'
		backgroundMusicNode.stream = backgroundMusicBase
	backgroundMusicNode.play()
	GameLevelLog.level_reached(level_id)
	load_level()

func _ready():
	backgroundMusicNode = %BackgroundMusicPlayer
	button_sound = %ButtonSound
	button_magic_sound = %ButtonMagicSound
	GameLevelLog.level_reached(0)
	if Engine.is_editor_hint():
		# Text files get a `.remap` extension added on export.
		_refresh_files()
	if auto_load:
		load_level()
