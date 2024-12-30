extends PathFollow2D

@export var m_rlSpeed: float = 0.05
@export var m_rlSpinSpeed: float = 400.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_ratio += delta * m_rlSpeed
	rotation_degrees += m_rlSpinSpeed * delta
	pass
