extends CanvasLayer

@onready var m_oSceneMain = $TtlMEMMainScreen
@onready var m_oSceneGame = $TtlMemGameScreen
@onready var m_oAudioMusicPlayer = $Music


# Called when the node enters the scene tree for the first time.
func _ready():
	TtlMEMSignalManager.on_game_exit_pressed.connect(_on_game_exit_pressed)
	TtlMEMSignalManager.on_level_selected.connect(_on_level_selected)
	_on_game_exit_pressed()

func ShowGame(a_fShow: bool) -> void:
	m_oSceneMain.visible = !a_fShow
	m_oSceneGame.visible = a_fShow

func _on_game_exit_pressed() -> void:
	ShowGame(false)
	TtlMEMSoundManager.PlaySound(m_oAudioMusicPlayer, TtlMEMSoundManager.s_szSoundMainMenu)
	TtlMEMGameManager.ClearNodesOfGroup(TtlMEMGameManager.s_szTileGroup)
	pass

func _on_level_selected(a_iLevelNum: int) -> void:
	ShowGame(true)
	TtlMEMSoundManager.PlaySound(m_oAudioMusicPlayer, TtlMEMSoundManager.s_szSoundInGame)
	pass
