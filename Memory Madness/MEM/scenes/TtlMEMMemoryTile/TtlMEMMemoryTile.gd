extends TextureButton

# This is how you make a class you can
# refer to from elsewhere in Godot.
# This is an improvement on just passing
# it in as a var, both for type safety,
# and because you can use the IDE to see
# your methods and variables.
class_name TtlMEMMemoryTile

@onready var m_oImageFrame = $FrameImage
@onready var m_oImageItem = $ItemImage

var m_szItemName: String
var m_fCanSelect: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	TtlMEMSignalManager.on_selection_disabled.connect(_on_selection_disabled)
	TtlMEMSignalManager.on_selection_enabled.connect(_on_selection_enabled)
	pass # Replace with function body.

func _on_selection_disabled() -> void:
	m_fCanSelect = false

func _on_selection_enabled() -> void:
	m_fCanSelect = true

func Reveal(m_fRevealTile: bool) -> void:
	m_oImageFrame.visible = m_fRevealTile
	m_oImageItem.visible = m_fRevealTile

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func KillOnSuccess() -> void:
	# Want to put the zindex of these towards the front.
	set_z_index(1)
	
	var oTween = get_tree().create_tween()
	# set_parallel makes these effects happen at the same time.
	oTween.set_parallel(true)
	oTween.tween_property(self, "disabled", true, 0)
	oTween.tween_property(self, "rotation", deg_to_rad(720), 0.5)
	oTween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.5)	
	
	# Once they all finish, we want a quick pause.
	oTween.set_parallel(false)
	oTween.tween_interval(0.6)
	
	# And then make the tile vanish. We don't delete it to maintain
	# the gridcontainer spacing as-is.
	oTween.tween_property(self, "scale", Vector2(0, 0), 0)

func Setup(a_oDictItemImage: Dictionary, a_oImageFrame: CompressedTexture2D) -> void:
	m_oImageFrame.texture = a_oImageFrame
	m_oImageItem.texture = a_oDictItemImage.m_oItemTexture
	m_szItemName = a_oDictItemImage.m_szItemName
	Reveal(false)


func _on_pressed():
	if m_fCanSelect:
		TtlMEMSignalManager.on_tile_selected.emit(self)
