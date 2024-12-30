extends TextureRect

const s_rsrsScaleSmall: Vector2 = Vector2(0.1, 0.1)
const s_rsrsScaleNormal: Vector2 = Vector2(1.0,1.0)
const s_rsMinSpinTime: float = 1.0
const s_rsMaxSpinTime: float = 2.0
const s_rsScaleTime: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	RunTween()
	pass # Replace with function body.

func GetRandomSpinTime() -> float:
	return randf_range(s_rsMinSpinTime, s_rsMaxSpinTime)

func GetRandomRotation() -> float:
	return deg_to_rad(randf_range(-360, 360))

func RunTween() -> void:
	var oTween = get_tree().create_tween()
	#oTween.set_loops(0)
	oTween.tween_callback(SetRandomImage)
	oTween.tween_property(self, "scale", s_rsrsScaleNormal, s_rsScaleTime)
	oTween.tween_property(self, "rotation", GetRandomRotation(), GetRandomSpinTime())
	oTween.tween_property(self, "rotation", GetRandomRotation(), GetRandomSpinTime())
	oTween.tween_property(self, "scale", s_rsrsScaleSmall, s_rsScaleTime)
	oTween.tween_callback(RunTween)

func SetRandomImage() -> void:
	texture = TtlMEMImageManager.GetRandomItemImageDict()[TtlMEMImageManager.s_szItemTexture]
