extends CharacterBody2D

class_name TtlFANPlayer

enum TtlFANPlayerState { IDLE, RUN, JUMP, FALL, HURT }

const s_rlBottomKillPlane: float = 200.0
const s_rlGravity: float = 690.0
const s_rlRunSpeed: float = 120.0
const s_rlMaxFall: float = 400.0
const s_rlJumpVelocity: float = -260.0

const s_rlrlHurtVelocity: Vector2 = Vector2(0, -130.0)

@onready var m_oSprite2D: Sprite2D = $Sprite2D
@onready var m_oLabelDebug: Label = $DebugLabel
@onready var m_oAnimationPlayer: AnimationPlayer = $AnimationPlayer
@onready var m_oShooter: TtlFANShooter = $TtlFANShooter

@onready var m_oTimerInvinciblity: Timer = $InvinciblityTimer
@onready var m_oAnimationInvincibility: AnimationPlayer = $InvincibilityPlayer
@onready var m_oTimerHurt: Timer = $HurtTimer


var m_eiState: TtlFANPlayerState = TtlFANPlayerState.IDLE
var m_fInvincible: bool = false
var m_iHealth: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	FallenOff()
	
	if not is_on_floor():
		velocity.y += s_rlGravity * delta
	
	GetInput()
	
	move_and_slide()
	
	CalculateState()
	UpdateDebugLabel()
	
	if Input.is_action_just_pressed("shoot"):
		Shoot()

func FallenOff() -> void:
	if global_position.y < s_rlBottomKillPlane:
		return
	ReduceHealth(m_iHealth)


func UpdateDebugLabel() -> void:
	m_oLabelDebug.text = "floor:%s inv: %s\n%s\nvel:(%.0f,%.0f)\n HP: %d" % [
		is_on_floor(), m_fInvincible,
		TtlFANPlayerState.keys()[m_eiState],
		velocity.x, velocity.y, 
		m_iHealth
	]

func Shoot() -> void:
	var rlrlDirection: Vector2
	if m_oSprite2D.flip_h:
		rlrlDirection = Vector2.LEFT
	else:
		rlrlDirection = Vector2.RIGHT
	m_oShooter.Shoot(
		rlrlDirection
	)

func GetInput() -> void:
	
	if m_eiState == TtlFANPlayerState.HURT:
		return
	
	velocity.x = 0
	
	if Input.is_action_pressed("left"):
		velocity.x -= s_rlRunSpeed
		m_oSprite2D.flip_h = true
	elif Input.is_action_pressed("right"):
		velocity.x += s_rlRunSpeed
		m_oSprite2D.flip_h = false
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = s_rlJumpVelocity
	
	velocity.y = clampf(velocity.y, s_rlJumpVelocity, s_rlMaxFall)

func CalculateState() -> void:
	
	# Bypass standard state calculation if we're in the middle
	# of being hurt.
	if m_eiState == TtlFANPlayerState.HURT:
		return
	
	if is_on_floor():
		if velocity.x == 0:
			SetState(TtlFANPlayerState.IDLE)
		else:
			SetState(TtlFANPlayerState.RUN)
	else:
		if velocity.y < 0:
			SetState(TtlFANPlayerState.JUMP)
		else:
			SetState(TtlFANPlayerState.FALL)
	

func SetState(a_eiNewState: TtlFANPlayerState) -> void:
	# If the new state is the same as the old one, it's a no-op.
	if a_eiNewState == m_eiState:
		return
	
	m_eiState = a_eiNewState
	
	# This is the switch equivalent!
	match m_eiState:
		TtlFANPlayerState.IDLE:
			m_oAnimationPlayer.play("idle")
		TtlFANPlayerState.RUN:
			m_oAnimationPlayer.play("run")
		TtlFANPlayerState.JUMP:
			m_oAnimationPlayer.play("jump")
		TtlFANPlayerState.FALL:
			m_oAnimationPlayer.play("fall")
		TtlFANPlayerState.HURT:
			HurtRecoil()

func ApplyHit() -> void:
	# Nothing happens if we're invincible.
	if m_fInvincible:
		return
	
	# Applies the damage, check if we died.
	if ReduceHealth(1) == false:
		return
	GoInvincible()
	SetState(TtlFANPlayerState.HURT)
	pass

# Returns a bool indicating whether we're still alive.
func ReduceHealth(a_iReduction: int) -> bool:
	m_iHealth -= a_iReduction
	TtlFANSignalManager.on_player_hit.emit(m_iHealth)
	
	if m_iHealth <= 0:
		TtlFANSignalManager.on_game_over.emit()
		# Stop physics on player death
		set_physics_process(false)
		print("Player died.")
		return false
	return true

func GoInvincible() -> void:
	m_fInvincible = true
	m_oAnimationInvincibility.play("invincible")
	m_oTimerInvinciblity.start()

func HurtRecoil() -> void:
	m_oAnimationPlayer.play("hurt")
	velocity = s_rlrlHurtVelocity
	m_oTimerHurt.start()

func OnInvincibilityTimerTimeout() -> void:
	m_fInvincible = false
	m_oAnimationInvincibility.stop()
	pass # Replace with function body.


func OnHitboxAreaEntered(area: Area2D) -> void:
	ApplyHit()


func OnHurtTimerTimeout() -> void:
	SetState(TtlFANPlayerState.IDLE)
	pass # Replace with function body.
