extends TtlFANEnemyBase

@onready var m_oRayFloorDetection: RayCast2D = $FloorDetection
@onready var m_oSpriteAnimated: AnimatedSprite2D = $AnimatedSprite2D

@export var m_rlSpeed: float = 50.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	# Basic movement.
	# If airborne, fall down, otherwise
	# set our left/right movement.
	if !is_on_floor():
		velocity.y += m_rlGravity * delta
	else:
		# Interesting if/else trick, didn't know you could do that.
		velocity.x = m_rlSpeed if m_oSpriteAnimated.flip_h else -m_rlSpeed
	
	move_and_slide()
	
	# Check if we need to turn around.
	if is_on_floor():
		if is_on_wall() or !m_oRayFloorDetection.is_colliding():
			FlipSnail()

func FlipSnail() -> void:
	m_oRayFloorDetection.position.x = -m_oRayFloorDetection.position.x
	m_oSpriteAnimated.flip_h = !m_oSpriteAnimated.flip_h
