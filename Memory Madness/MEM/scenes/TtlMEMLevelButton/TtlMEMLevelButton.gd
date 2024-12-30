extends TextureButton

@onready var m_oLabel = $Label
@onready var m_oSound = $Sound

var m_iLevelNumber: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func SetLevelNumber(a_iLevelNumber: int) -> void:
	m_iLevelNumber = a_iLevelNumber
	var oDictLevelData = TtlMEMGameManager.s_oDictLevels[m_iLevelNumber]
	m_oLabel.text = "%sx%s" % [oDictLevelData.rows, oDictLevelData.cols]


func _on_pressed():
	TtlMEMSoundManager.PlayButtonClick(m_oSound)
	TtlMEMSignalManager.on_level_selected.emit(m_iLevelNumber)
	pass # Replace with function body.
