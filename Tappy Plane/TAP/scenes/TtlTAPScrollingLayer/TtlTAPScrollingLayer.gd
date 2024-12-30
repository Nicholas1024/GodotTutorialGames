extends ParallaxLayer

@onready var m_oSprite = $Sprite2D

@export var m_oTexture: Texture
@export var m_rsScrollScale: float = 0.0
@export var m_rsTextureWidth: float = 1920.0
@export var m_rsTextureHeight: float = 1080.0

# Called when the node enters the scene tree for the first time.
func _ready():
	motion_scale.x = m_rsScrollScale
	var rsrsViewportSize = get_viewport_rect().size
	var rsScale = rsrsViewportSize.y/m_rsTextureHeight
	
	m_oSprite.scale = Vector2(rsScale, rsScale)
	motion_mirroring.x = m_rsTextureWidth * rsScale
	m_oSprite.texture = m_oTexture
	
	pass # Replace with function body.
