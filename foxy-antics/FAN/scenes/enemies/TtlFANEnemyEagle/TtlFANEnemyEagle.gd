extends TtlFANEnemyBase

@onready var m_oSpriteAnimated: AnimatedSprite2D = $AnimatedSprite2D
@onready var m_oTimerDirection: Timer = $DirectionTimer
@onready var m_oShooter: TtlFANShooter = $TtlFANShooter
@onready var m_oRayPlayerDetector: RayCast2D = $PlayerDetector

const s_rlrlFlySpeed: Vector2 = Vector2(35, 15)

var m_rlrlFlyDirection: Vector2 = Vector2.ZERO # Going to be either (-1, 1) or (1,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	velocity = m_rlrlFlyDirection
	move_and_slide()
	ShootIfAbovePlayer()
	pass

func ShootIfAbovePlayer() -> void:
	if m_oRayPlayerDetector.is_colliding():
		m_oShooter.Shoot(
			global_position.direction_to(m_oPlayerRef.global_position)
		)

func FlyToPlayer() -> void:
	var iXDir = sign(m_oPlayerRef.global_position.x - global_position.x)
	
	m_oSpriteAnimated.flip_h = (iXDir > 0)
	
	m_rlrlFlyDirection = Vector2(iXDir, 1) * s_rlrlFlySpeed

func OnDirectionTimerTimeout() -> void:
	FlyToPlayer()
	pass # Replace with function body.

func OnScreenEntered() -> void:
	m_oSpriteAnimated.play("fly")
	m_oTimerDirection.start()
	FlyToPlayer()
