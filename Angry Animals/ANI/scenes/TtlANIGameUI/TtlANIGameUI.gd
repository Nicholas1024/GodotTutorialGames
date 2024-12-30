extends Control

const s_oSceneMainMenu = preload("res://ANI/scenes/TtlANIMainMenu/TtlANIMainMenu.tscn")

@onready var m_oLevelLabel = $MarginContainer/VBoxContainer/LevelLabel
@onready var m_oAttemptsLabel = $MarginContainer/VBoxContainer/AttemptsLabel
@onready var m_oGameSound = $GameSound
@onready var m_oLevelCompleteContainer = $MarginContainer/LevelCompleteContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	m_oLevelLabel.text = "Level %s" % TtlANIScoreManager.GetLevelSelected()
	TtlANISignalManager.on_score_updated.connect(UpdateAttempts)
	TtlANISignalManager.on_level_complete.connect(OnLevelComplete)
	UpdateAttempts(0)

func UpdateAttempts(a_iAttempts: int):
	m_oAttemptsLabel.text = "Attempts: %s" % a_iAttempts

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_packed(s_oSceneMainMenu)

func OnLevelComplete():
	m_oLevelCompleteContainer.show()
	m_oGameSound.play()
