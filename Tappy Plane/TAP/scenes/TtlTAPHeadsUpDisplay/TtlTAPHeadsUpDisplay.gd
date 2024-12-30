extends Control

@onready var m_oScoreLabel = $MarginContainer/ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	TtlTAPSignalManager.on_score_updated.connect(on_score_updated)
	pass # Replace with function body.

func on_score_updated():
	m_oScoreLabel.text = str(TtlTAPScoreManager.GetScore())
