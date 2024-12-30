extends TtlFANEnemyBase

@onready var m_oAnimatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var m_oTimerJump: Timer = $JumpTimer

const s_rlJumpVelocityX: float = 100
const s_rlJumpVelocityY: float = 150

const s_rlrlJumpVelocityLeft: Vector2 = Vector2(-s_rlJumpVelocityX, -s_rlJumpVelocityY)
const s_rlrlJumpVelocityRight: Vector2 = Vector2(s_rlJumpVelocityX, -s_rlJumpVelocityY)

const s_rlJumpMinTime: float = 2.0
const s_rlJumpMaxTime: float = 4.0

var m_fJump: bool = false
var m_fSeenPlayer: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if !is_on_floor():
		velocity.y += m_rlGravity * delta
	else:
		velocity.x = 0
		m_oAnimatedSprite.play("idle")
	
	ApplyJump()
	move_and_slide()
	if is_on_floor():
		FlipFrog()
	pass

func FlipFrog() -> void:
	m_oAnimatedSprite.flip_h = (m_oPlayerRef.global_position.x > global_position.x)

func ApplyJump() -> void:
	if !is_on_floor():
		return
	
	if !m_fJump or !m_fSeenPlayer:
		return
	
	# If you get here, the frog is currently on the floor,
	# has seen the player, and is currently allowed to jump.
	
	if m_oAnimatedSprite.flip_h:
		velocity = s_rlrlJumpVelocityRight
	else:
		velocity = s_rlrlJumpVelocityLeft
	
	# As we've started a jump, set the can jump flag to false.
	m_fJump = false
	m_oAnimatedSprite.play("jump")
	
	# Finally, start the timer for when we can jump again.
	StartTimer()

func StartTimer() -> void:
	m_oTimerJump.wait_time = randf_range(s_rlJumpMinTime, s_rlJumpMaxTime)
	m_oTimerJump.start()

func ResetJump() -> void:
	m_fJump = true

# Overriding the base method. Note that the blue arrow
# signals an override, and the green box indicates being hooked up to a signal.
func OnScreenEntered() -> void:
	m_fSeenPlayer = true
	StartTimer()
	pass
