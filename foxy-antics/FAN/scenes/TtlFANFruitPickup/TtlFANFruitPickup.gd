extends Area2D

@onready var m_oSpriteAnimated: AnimatedSprite2D = $AnimatedSprite2D
@onready var m_oTimerLife: Timer = $LifeTimer

const s_rlGravity: float = 160.0
const s_rlJump: float = -120.0
const s_iPoints: int = 2

var m_rlStartY: float
var m_rlSpeedY: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_rlStartY = position.y
	m_rlSpeedY = s_rlJump
	# Code to pick a random animation from the animated sprite.
	# Effectively gives us a random fruit pickup.
	var oaszAnimationNames: Array[String] = []
	for szAnimationName in m_oSpriteAnimated.sprite_frames.get_animation_names():
		oaszAnimationNames.push_back(szAnimationName)
	m_oSpriteAnimated.animation = oaszAnimationNames.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += m_rlSpeedY * delta
	m_rlSpeedY += s_rlGravity * delta
	
	if position.y > m_rlStartY:
		position.y = m_rlStartY
		set_process(false)
	

func KillMe() -> void:
	hide()
	queue_free()

func OnTimerTimeout() -> void:
	KillMe()


func OnAreaEntered(area: Area2D) -> void:
	# For now, we just emit a signal.
	TtlFANSignalManager.on_pickup_hit.emit(s_iPoints)
