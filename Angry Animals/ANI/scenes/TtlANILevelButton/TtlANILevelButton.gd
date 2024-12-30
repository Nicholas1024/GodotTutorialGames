extends TextureButton


const s_rsrsHoverScale: Vector2 = Vector2(1.1, 1.1)
const s_rsrsDefaultScale: Vector2 = Vector2(1.0, 1.0)

@export var m_iLevelNumber: int = -1

@onready var m_oLevelLabel = $MarginContainer/VBoxContainer/LevelLabel
@onready var m_oScoreLabel = $MarginContainer/VBoxContainer/ScoreLabel

var m_oLevelScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	m_oLevelLabel.text = str(m_iLevelNumber)
	m_oScoreLabel.text = str(TtlANIScoreManager.GetScoreForLevel(str(m_iLevelNumber)))
	m_oLevelScene = load("res://ANI/scenes/TtlANILevel/TtlANILevel%d.tscn" % m_iLevelNumber)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	TtlANIScoreManager.SetLevelSelected(m_iLevelNumber)
	get_tree().change_scene_to_packed(m_oLevelScene)



func _on_mouse_entered():
	scale = s_rsrsHoverScale


func _on_mouse_exited():
	scale = s_rsrsDefaultScale
