extends Node

const s_iDefaultScore: int = 1024
const s_szPathScores = "user://high_scores.json"

var m_iLevelSelected: int = -1
var m_oDictLevelScores: Dictionary = {}

# Dictionary initialization reference:
# oExampleDict = {
#   "age": 32
#   "name": "Bruce Wayne",
#   "address": {
#      "street": "Crime alley",
#      "city": "Gotham"
#   }
# }
# Can access values via:
# oExampleDict["age"]
# oExampleDict.name
# oExampleDict["address"].street
# oExampleDict.address.city
#
# Sounds like keys in gdscript can be whatever,
# but since we want to save the data as JSON, we'll
# want to keep keys to just strings.
#
# Trying to access a key that doesn't exist will crash.


# Called when the node enters the scene tree for the first time.
func _ready():
	LoadFromDisc()

func SetLevelSelected(a_iLevelSelected: int) -> void:
	m_iLevelSelected = a_iLevelSelected

func GetLevelSelected() -> int:
	return m_iLevelSelected

# It's a safe getter, as it'll initialize and return the default value if
# there's no value for the key.
func GetScoreForLevel(a_szCurrentLevel: String) -> int:
	if !m_oDictLevelScores.has(a_szCurrentLevel):
		m_oDictLevelScores[a_szCurrentLevel] = s_iDefaultScore
	return m_oDictLevelScores[a_szCurrentLevel]

# Updates the level score if it's a new best score.
# Returns true if an update was performed.
func UpdateScoreForLevel(a_iLevelScore: int, a_szCurrentLevel: String) -> bool:
	if a_iLevelScore < GetScoreForLevel(a_szCurrentLevel):
		m_oDictLevelScores[a_szCurrentLevel] = a_iLevelScore
		SaveToDisc()
		return true
	return false

func ResetLevelScores():
	m_oDictLevelScores.clear()

func SaveToDisc():
	var oFile = FileAccess.open(s_szPathScores, FileAccess.WRITE)
	var szJsonScores = JSON.stringify(m_oDictLevelScores)
	oFile.store_string(szJsonScores)

func LoadFromDisc():
	var oFile = FileAccess.open(s_szPathScores, FileAccess.READ)
	if oFile == null:
		SaveToDisc()
	else:
		var szData = oFile.get_as_text()
		m_oDictLevelScores = JSON.parse_string(szData)
		
