extends Control

@export var m_oSceneMemoryTile: PackedScene

@onready var m_oAudioSoundPlayer = $Sound

@onready var m_oGridContainerTiles = $HB/MC1/TileContainer
@onready var m_oLabelMoves = $HB/MC2/VB/HB/MovesLabel
@onready var m_oLabelPairs = $HB/MC2/VB/HB2/PairsLabel

@onready var m_oScorer: TtlMEMScorer = $TtlMemScorer


# Called when the node enters the scene tree for the first time.
func _ready():
	TtlMEMSignalManager.on_level_selected.connect(_on_level_selected)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	m_oLabelMoves.text = m_oScorer.GetMovesMadeString()
	m_oLabelPairs.text = m_oScorer.GetPairsMadeString()
	pass

func _on_level_selected(a_iLevelNum: int) -> void:
	# First things first, clear out any old stuff.
	#
	# Saving the way I did it myself first.
	#var oaoOldTiles = m_oGridContainerTiles.get_children()
	#for oOldTile in oaoOldTiles:
	#	m_oGridContainerTiles.remove_child(oOldTile)
	#	oOldTile.queue_free()
	#
	
	var oDictLevelSelection = TtlMEMGameManager.GetLevelSelection(a_iLevelNum)
	var oFrameImage = TtlMEMImageManager.GetRandomFrameImage()
	
	m_oGridContainerTiles.columns = oDictLevelSelection.m_iNumCols
	
	for oDictItemImage in oDictLevelSelection.m_oaoImageList:
		AddMemoryTile(oDictItemImage, oFrameImage)
	
	m_oScorer.ClearNewGame(oDictLevelSelection.m_iTargetPairs)
	pass

func AddMemoryTile(a_oDictItemImage: Dictionary, a_oImageFrame: CompressedTexture2D) -> void:
	var oMemoryTile = m_oSceneMemoryTile.instantiate()
	m_oGridContainerTiles.add_child(oMemoryTile)
	oMemoryTile.Setup(a_oDictItemImage, a_oImageFrame)
	pass

func _on_exit_button_pressed():
	TtlMEMSignalManager.on_game_exit_pressed.emit()
	TtlMEMSoundManager.PlayButtonClick(m_oAudioSoundPlayer)
	pass # Replace with function body.
