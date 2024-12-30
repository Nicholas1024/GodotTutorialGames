extends Control

@onready var m_oHSScore = $MarginContainer/HSScore


# Called when the node enters the scene tree for the first time.
func _ready():
	m_oHSScore.text = str(TtlTAPScoreManager.GetHighScore())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Start Game"):
		TtlTAPGameManager.LoadGameScene()
