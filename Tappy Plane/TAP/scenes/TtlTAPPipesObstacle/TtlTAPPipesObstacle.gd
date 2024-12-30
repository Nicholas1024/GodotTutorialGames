extends Node2D

class_name TtlTapPipesObstacle

@export var m_rsSpeed: float = 120.0
@onready var m_oSoundScore = $ScoreSound

var m_fPaused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= m_rsSpeed * delta

func Disappear()->void:
	queue_free()

func _on_screen_exited()->void:
	Disappear()
	pass # Replace with function body.


func _on_pipe_body_entered(body):
	# If you want to sort by class, this
	# would be how:
	# if body is TtlTAPPlane:
	
	if body.is_in_group(TtlTAPGameManager.s_oszGroupPlayer):
		body.PlaneCrash()
	pass # Replace with function body.


func _on_laser_body_exited(body):
	if body.is_in_group(TtlTAPGameManager.s_oszGroupPlayer) and TtlTAPGameManager.m_rfGameRunning:
		TtlTAPScoreManager.IncrementScore()
		m_oSoundScore.play()
	pass # Replace with function body.
