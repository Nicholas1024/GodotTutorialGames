extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("bullet"):
		TtlFANSignalManager.on_create_bullet.emit(
			Vector2(50,-50),
			Vector2(100, -10),
			3.0,
			40.0,
			TtlFANConstants.TtlFANObjectType.BULLET_PLAYER
		)
	pass
