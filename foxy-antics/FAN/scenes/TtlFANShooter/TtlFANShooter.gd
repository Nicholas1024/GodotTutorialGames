extends Node2D

class_name TtlFANShooter

@onready var m_oTimerShoot: Timer = $ShootTimer
@onready var m_oAudioStreamPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var m_rlBulletSpeed: float = 50.0
@export var m_rlBulletLifespan: float = 10.0
@export var m_eiBulletType: TtlFANConstants.TtlFANObjectType
@export var m_rlShootDelay: float = 0.7

var m_fCanShoot: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_oTimerShoot.wait_time = m_rlShootDelay


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Shoot(a_rlrlDirection: Vector2) -> void:
	if !m_fCanShoot:
		return
	
	# We only want to shoot once.
	m_fCanShoot = false
	
	TtlFANSignalManager.on_create_bullet.emit(
		global_position,
		a_rlrlDirection,
		m_rlBulletLifespan,
		m_rlBulletSpeed,
		m_eiBulletType
	)
	
	m_oTimerShoot.start()

func OnShootTimerTimeout() -> void:
	m_fCanShoot = true
