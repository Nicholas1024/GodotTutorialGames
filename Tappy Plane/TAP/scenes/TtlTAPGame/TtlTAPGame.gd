extends Node2D

class_name TtlTAPGame

@export var m_oPipesObstacle: PackedScene

@export var m_oPipesTimer: Timer

@onready var m_oPipesHolder = $PipesHolder

var m_fGameRunning = true
# Called when the node enters the scene tree for the first time.
func _ready():
	TtlTAPScoreManager.SetScore(0)
	TtlTAPSignalManager.on_plane_died.connect(_on_plane_died)
	TtlTAPGameManager.m_rfGameRunning = true
	randomize()
	SpawnPipe()
	pass # Replace with function body.

func SpawnPipe() -> void:
	var oPipesObstacle = m_oPipesObstacle.instantiate()
	oPipesObstacle.position = Vector2(550, randf_range(150, 650))
	m_oPipesHolder.add_child(oPipesObstacle)

func _on_spawn_timer_timeout():
	SpawnPipe()

func StopPipes():
	m_oPipesTimer.stop()
	var oaoPipesObstacles:Array[Node] = m_oPipesHolder.get_children()
	
	for oPipesObstacle in oaoPipesObstacles:
		oPipesObstacle.set_process(false)

func _on_plane_died():
	TtlTAPGameManager.m_rfGameRunning = false
	StopPipes()
