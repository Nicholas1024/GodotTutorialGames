extends Control

@export var m_oSceneLevelButton: PackedScene
@onready var m_oHBoxLevels = $VBoxContainer/HBoxLevels

# Called when the node enters the scene tree for the first time.
func _ready():
	SetupGrid()
	pass # Replace with function body.

func CreateLevelButton(a_iLevelNumber: int) ->void:
	var oNewLevelButton = m_oSceneLevelButton.instantiate()
	m_oHBoxLevels.add_child(oNewLevelButton)
	oNewLevelButton.SetLevelNumber(a_iLevelNumber)

func SetupGrid() -> void:
	for iLevel in TtlMEMGameManager.s_oDictLevels:
		CreateLevelButton(iLevel)
