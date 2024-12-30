extends Node

var m_uiScore: int = 0
var m_uiHighScore: int = 0

func GetScore() -> int:
	return m_uiScore

func GetHighScore() -> int:
	return m_uiHighScore

func SetScore(a_uiScore: int) -> void:
	print("Set score: ", a_uiScore)
	m_uiScore = a_uiScore
	TtlTAPSignalManager.on_score_updated.emit()
	if m_uiScore > m_uiHighScore:
		m_uiHighScore = m_uiScore
		print("New high score: ", m_uiHighScore)

func IncrementScore() -> void:
	SetScore(m_uiScore + 1)

func ResetHighScore() -> void:
	m_uiHighScore = 0
