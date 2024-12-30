extends Control

@onready var m_oLabelMoves = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/MovesLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	TtlMEMSignalManager.on_game_over.connect(_on_game_over)
	pass # Replace with function body.

func _on_game_over(a_iNumMoves: int) -> void:
	m_oLabelMoves.text = str(a_iNumMoves)
	show()

func _on_exit_button_pressed():
	hide()
	TtlMEMSignalManager.on_game_exit_pressed.emit()
