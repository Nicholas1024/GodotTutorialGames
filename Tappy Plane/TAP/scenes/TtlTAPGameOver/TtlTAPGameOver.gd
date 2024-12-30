extends Control

@onready var m_oLabelGameOver = $GameOverLabel
@onready var m_oLabelRestart = $RestartLabel
@onready var m_oTimer:Timer = $Timer
@onready var m_oSoundGameOver = $GameOverSound


var m_fGameIsOver:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# hide() sets visibility to false,
	# show() sets visibility to true.
	hide()
	TtlTAPSignalManager.on_plane_died.connect(_on_plane_died)

func _on_timer_timeout():
	SwitchLabels()

func _on_plane_died() -> void:
	ShowGameOver()
	m_oSoundGameOver.play()

func ShowGameOver() -> void:
	show()
	m_fGameIsOver = true
	m_oTimer.start()

func SwitchLabels() -> void:
	if m_oLabelGameOver.is_visible():
		m_oLabelGameOver.hide()
		m_oLabelRestart.show()
	else:
		m_oLabelGameOver.show()
		m_oLabelRestart.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if m_fGameIsOver:
		if Input.is_action_just_pressed("Restart Game"):
			TtlTAPGameManager.LoadGameScene()
		if Input.is_action_just_pressed("Quit Game"):
			TtlTAPGameManager.LoadMainScene()


