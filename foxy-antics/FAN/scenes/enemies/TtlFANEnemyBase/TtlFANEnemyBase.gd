extends CharacterBody2D

class_name TtlFANEnemyBase

@export var m_iPoints: int = 1

var m_oPlayerRef: TtlFANPlayer

const s_rlOffscrenKillplane: float = 200.0

var m_rlGravity: float = 800.0
var m_fDying: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	m_oPlayerRef = get_tree().get_first_node_in_group(TtlFANConstants.s_szPlayerGroup)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	FallenOff()

func FallenOff() -> void:
	if global_position.y > s_rlOffscrenKillplane:
		queue_free()


func Die():
	if m_fDying:
		return
	
	m_fDying = true
	
	set_physics_process(false)
	hide()
	
	# Later we're going to instantiate
	# a sound, drop a pick-up, and make
	# an explosion sprite.
	TtlFANSignalManager.on_create_object.emit(
		global_position,
		TtlFANConstants.TtlFANObjectType.EXPLOSION
	)
	TtlFANSignalManager.on_create_object.emit(
		global_position,
		TtlFANConstants.TtlFANObjectType.PICKUP
	)
	
	queue_free()


func OnHitboxAreaEntered(area: Area2D) -> void:
	Die()


func OnScreenEntered() -> void:
	pass # Replace with function body.
