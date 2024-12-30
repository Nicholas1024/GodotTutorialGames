extends Node

class_name TtlMEMScorer

@onready var m_oSoundPlayer = $Sound
@onready var m_oTimerReveal = $RevealTimer


var m_oaoSelections: Array = []
var m_iTargetPairs: int = 0
var m_iMovesMade: int = 0
var m_iPairsMade: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	TtlMEMSignalManager.on_tile_selected.connect(_on_tile_selected)
	TtlMEMSignalManager.on_game_exit_pressed.connect(_on_game_exit_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func GetMovesMadeString() -> String:
	return str(m_iMovesMade)

func GetPairsMadeString() -> String:
	return "%s / %s" % [ m_iPairsMade, m_iTargetPairs ]

func ClearNewGame(a_iTargetPairs: int) -> void:
	m_oaoSelections.clear()
	m_iMovesMade = 0
	m_iPairsMade = 0
	m_iTargetPairs = a_iTargetPairs

func CheckGameOver() -> void:
	if m_iPairsMade >= m_iTargetPairs:
		TtlMEMSignalManager.on_game_over.emit(m_iMovesMade)

func SelectionsArePair() -> bool:
	return (m_oaoSelections[0].m_szItemName == m_oaoSelections[1].m_szItemName)

func UpdateSelections() -> void:
	m_oTimerReveal.start()
	if SelectionsArePair():
		OnPairMade()

func OnPairMade() -> void:
	for oSelectedTile: TtlMEMMemoryTile in m_oaoSelections:
		oSelectedTile.KillOnSuccess()
	m_iPairsMade += 1
	TtlMEMSoundManager.PlaySound(m_oSoundPlayer, TtlMEMSoundManager.s_szSoundSuccess)


func HideSelections() -> void:
	for oSelectedTile in m_oaoSelections:
		oSelectedTile.Reveal(false)

func CheckPairMade() -> void:
	# If we haven't selected two tiles, nothing happens.
	if m_oaoSelections.size() < 2:
		return
	
	# If we have, delay any further selection for the moment.
	TtlMEMSignalManager.on_selection_disabled.emit()
	
	# Add one to the number of moves made, as we've checked a pair.
	m_iMovesMade += 1
	
	UpdateSelections()

func _on_tile_selected(a_oTile: TtlMEMMemoryTile) -> void:
	# Don't do anything if the tile was already selected.
	if (m_oaoSelections.size() >= 1 and 
		m_oaoSelections[0].get_instance_id() == a_oTile.get_instance_id()):
		return
	
	# Otherwise, reveal the tile, play the sound, and check if we made a pair.
	a_oTile.Reveal(true)	
	m_oaoSelections.append(a_oTile)
	TtlMEMSoundManager.PlayTileClick(m_oSoundPlayer)
	CheckPairMade()


func _on_reveal_timer_timeout():
	if !SelectionsArePair():
		HideSelections()
	m_oaoSelections.clear()
	CheckGameOver()
	TtlMEMSignalManager.on_selection_enabled.emit()

func _on_game_exit_pressed() -> void:
	m_oTimerReveal.stop()
