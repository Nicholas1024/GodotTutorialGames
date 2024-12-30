extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready():
	TtlTAPSignalManager.on_plane_died.connect(on_plane_died)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll_offset.x -= TtlTAPGameManager.s_rsScrollSpeed * delta
	pass

func on_plane_died():
	StopScrolling()

func StopScrolling():
	set_process(false)
