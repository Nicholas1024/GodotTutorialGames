extends Node

signal on_create_bullet(
		a_rlrlPosition: Vector2,
		a_rlrlDirection: Vector2,
		a_rlLifespan: float,
		a_rlSpeed: float,
		a_eiObjectType: TtlFANConstants.TtlFANObjectType
)

signal on_create_object(
	a_rlrlPosition: Vector2,
	a_eiObjectType: TtlFANConstants.TtlFANObjectType
)

signal on_pickup_hit(
	a_iPoints: int
)

signal on_game_over()
signal on_player_hit(a_iCurrentHealth: int)
