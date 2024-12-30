extends Node

var m_iAttempts: int = 0
var m_iTargetsHit: int = 0
var m_iTotalTargets: int = 0
var m_iLevelNumber: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Counting all the nodes in the scene tree belonging to a specific group.
	m_iTotalTargets = get_tree().get_nodes_in_group("target").size()
	m_iLevelNumber = TtlANIScoreManager.GetLevelSelected()
	TtlANISignalManager.on_attempt_made.connect(IncrementAttempts)
	TtlANISignalManager.on_target_destroyed.connect(IncrementTargetsHit)

func IncrementAttempts()->void:
	m_iAttempts += 1
	TtlANISignalManager.on_score_updated.emit(m_iAttempts)

func IncrementTargetsHit()->void:
	m_iTargetsHit += 1
	if m_iTargetsHit >= m_iTotalTargets:
		TtlANIScoreManager.UpdateScoreForLevel(m_iAttempts, str(m_iLevelNumber))
		TtlANISignalManager.on_level_complete.emit()
