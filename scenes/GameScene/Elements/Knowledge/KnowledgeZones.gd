extends VBoxContainer

var minningNode : Node
var mysticismNode : Node
var explorationNode : Node

var mageMinAdv : Node
var mageMinTha : Node

var mageMysAdv : Node
var mageMysTha : Node
var mageMysEvo : Node

var mageExpTha : Node
var mageExpEvo : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	minningNode = %MinningK
	mysticismNode = %MysticismK
	explorationNode = %ExplorationK
	
	mageMinAdv = %MinMageAdivination
	mageMinTha = %MinMageThaumaturgy
	
	mageMysAdv = %MysMageAdivination
	mageMysTha = %MysMageThaumaturgy
	mageMysEvo = %MysMageEvocation
	
	mageExpEvo = %ExpMageEvocation
	mageExpTha = %ExpMageThaumaturgy
	pauseAllKnowledges()
	
	var saved_state = StateManager.knowledges_state
	for knowlegeData in saved_state:
		if saved_state[knowlegeData]["pause"] == false:
			if saved_state[knowlegeData]["knowledge_type"] == 0:
				minning_animations()
			if saved_state[knowlegeData]["knowledge_type"] == 1:
				exploration_animations()
			if saved_state[knowlegeData]["knowledge_type"] == 2:
				mysticim_animations()

func pauseAllKnowledges():
	minningNode.pause = true
	mageMinAdv.get_node("AnimatedSprite2D").stop()
	mageMinTha.get_node("AnimatedSprite2D").stop()
	mysticismNode.pause = true
	mageMysAdv.get_node("AnimatedSprite2D").stop()
	mageMysTha.get_node("AnimatedSprite2D").stop()
	mageMysEvo.get_node("AnimatedSprite2D").stop()
	explorationNode.pause = true
	mageExpEvo.get_node("AnimatedSprite2D").stop()
	mageExpTha.get_node("AnimatedSprite2D").stop()

func saveAllKnowledges():
	minningNode.save_state()
	mysticismNode.save_state()
	explorationNode.save_state()

func minning_animations():
	pauseAllKnowledges()
	minningNode.pause = false
	minningNode.save_state()
	mageMinAdv.get_node("AnimatedSprite2D").play("default")
	mageMinTha.get_node("AnimatedSprite2D").play("default")

func _on_minning_tb_pressed():
	minning_animations()
	saveAllKnowledges()

func mysticim_animations():
	pauseAllKnowledges()
	mysticismNode.pause = false
	mysticismNode.save_state()
	mageMysAdv.get_node("AnimatedSprite2D").play("default")
	mageMysTha.get_node("AnimatedSprite2D").play("default")
	mageMysEvo.get_node("AnimatedSprite2D").play("default")

func _on_mysticim_tb_pressed():
	mysticim_animations()
	saveAllKnowledges()

func exploration_animations():
	pauseAllKnowledges()
	explorationNode.pause = false
	explorationNode.save_state()
	mageExpEvo.get_node("AnimatedSprite2D").play("default")
	mageExpTha.get_node("AnimatedSprite2D").play("default")

func _on_exploration_tb_pressed():
	exploration_animations()
	saveAllKnowledges()
