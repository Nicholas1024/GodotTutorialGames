extends Node2D

const s_oDictObjectScenes: Dictionary = {
	TtlFANConstants.TtlFANObjectType.BULLET_PLAYER: 
		preload("res://FAN/scenes/TtlFANBulletPlayer/TtlFANBulletPlayer.tscn"),
	TtlFANConstants.TtlFANObjectType.BULLET_ENEMY: 
		preload("res://FAN/scenes/TtlFANBulletEnemy/TtlFANBulletEnemy.tscn"),
	TtlFANConstants.TtlFANObjectType.EXPLOSION:
		preload("res://FAN/scenes/TtlFANExplosion/TtlFANExplosion.tscn"),
	TtlFANConstants.TtlFANObjectType.PICKUP:
		preload("res://FAN/scenes/TtlFANFruitPickup/TtlFANFruitPickup.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TtlFANSignalManager.on_create_bullet.connect(OnCreateBullet)
	TtlFANSignalManager.on_create_object.connect(OnCreateObject)
	pass # Replace with function body.

func OnCreateBullet(
		a_rlrlPosition: Vector2,
		a_rlrlDirection: Vector2,
		a_rlLifespan: float,
		a_rlSpeed: float,
		a_eiObjectType: TtlFANConstants.TtlFANObjectType) -> void:
	
	if !s_oDictObjectScenes.has(a_eiObjectType):
		return
	
	var oNewBullet: TtlFANBulletBase = s_oDictObjectScenes[a_eiObjectType].instantiate()
	oNewBullet.Init(a_rlrlPosition, a_rlrlDirection, a_rlSpeed, a_rlLifespan)
	call_deferred("add_child", oNewBullet)

func OnCreateObject(
		a_rlrlPosition: Vector2,
		a_eiObjectType: TtlFANConstants.TtlFANObjectType
) -> void:
	if !s_oDictObjectScenes.has(a_eiObjectType):
		return
	
	var oCreatedObject = s_oDictObjectScenes[a_eiObjectType].instantiate()
	oCreatedObject.global_position = a_rlrlPosition
	call_deferred("add_child", oCreatedObject)
