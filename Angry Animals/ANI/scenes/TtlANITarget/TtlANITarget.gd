extends StaticBody2D

@onready var m_oAnimationPlayer = $AnimationPlayer


func Die()->void:
	m_oAnimationPlayer.play("vanish")



func _on_animation_player_animation_finished(anim_name):
	TtlANISignalManager.on_target_destroyed.emit()
	queue_free()
