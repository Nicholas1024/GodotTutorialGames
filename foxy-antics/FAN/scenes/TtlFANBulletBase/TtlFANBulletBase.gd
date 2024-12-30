extends Area2D

class_name TtlFANBulletBase

var m_rlrlDirection: Vector2 = Vector2(100,0)
var m_rlLifeSpan: float = 5.0
var m_rlLifeTime: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += m_rlrlDirection * delta
	
	CheckExpired(delta)

func CheckExpired(a_rlDelta: float) -> void:
	m_rlLifeTime += a_rlDelta
	if m_rlLifeTime > m_rlLifeSpan:
		queue_free()

func Init(a_rlrlPosition: Vector2, 
			a_rlrlDirection: Vector2, 
			a_rlSpeed: float, 
			a_rlLifespan: float) -> void:
	m_rlrlDirection = a_rlrlDirection.normalized() * a_rlSpeed
	m_rlLifeSpan = a_rlLifespan
	global_position = a_rlrlPosition
	



func OnAreaEntered(a_oArea: Area2D) -> void:
	queue_free()
	pass # Replace with function body.
