extends RigidBody2D

@onready var m_oLabel = $Label
@onready var m_oStretchSound = $StretchSound
@onready var m_oLaunchSound = $LaunchSound
@onready var m_oKickSound = $KickSound
@onready var m_oArrow = $Arrow

enum TtlANIAnimalState { READY, DRAG, RELEASE }

var m_iEnumAnimalState: TtlANIAnimalState = TtlANIAnimalState.READY

# We keep track of DragStart and AnimalStart separately
# so you can grab any part of the animal.
var m_rsrsDragStart: Vector2 = Vector2.ZERO
var m_rsrsAnimalStart: Vector2 = Vector2.ZERO

# TotalDrag is the displacement from where the drag started,
# PreviousDrag is the same, but for the previous frame of activity.
var m_rsrsTotalDrag: Vector2 = Vector2.ZERO
var m_rsrsPreviousDrag: Vector2 = Vector2.ZERO

var m_uiLastCollisionCount: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	m_oArrow.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	Update(delta)
	
	# Debug code to track the drag and current animal state.
	m_oLabel.text = "%s" % TtlANIAnimalState.keys()[m_iEnumAnimalState]
	m_oLabel.text += "\n%.1f, %.1f" % [m_rsrsTotalDrag.x, m_rsrsTotalDrag.y]


# This splits into functions for each AnimalState.
func Update(a_rsDelta: float) -> void:
	match m_iEnumAnimalState:
		TtlANIAnimalState.READY:
			pass
		TtlANIAnimalState.DRAG:
			UpdateDrag()
		TtlANIAnimalState.RELEASE:
			UpdateFlight()


# Sets the new state, handling any other details we need along the way.
func SetNewState(a_iEnumNewState: TtlANIAnimalState) -> void:
	m_iEnumAnimalState = a_iEnumNewState
	if m_iEnumAnimalState == TtlANIAnimalState.RELEASE:
		freeze = false
		apply_impulse(GetImpulse())
		m_oLaunchSound.play()
		m_oArrow.hide()
		TtlANISignalManager.on_attempt_made.emit()
	elif m_iEnumAnimalState == TtlANIAnimalState.DRAG:
		m_rsrsAnimalStart = global_position
		m_rsrsDragStart = get_global_mouse_position()
		m_rsrsTotalDrag = Vector2(0,0)
		m_oArrow.show()


# Updates the drag and animal position
# based on current mouse position.
func UpdateDrag() -> void:
	# If we've released the animal, nothing else happens.
	if DetectRelease():
		return
	
	# Otherwise, let's go ahead and update the drag variables.
	var rsrsGlobalMousePosition = get_global_mouse_position()
	m_rsrsPreviousDrag = m_rsrsTotalDrag
	m_rsrsTotalDrag = ClampVector(rsrsGlobalMousePosition - m_rsrsDragStart,
									-200, 0, 0, 200)
	# Next the position and the angle of our arrow.
	global_position = m_rsrsTotalDrag + m_rsrsAnimalStart
	UpdateArrow()
	
	# And finally, check if we need to play the stretch sound.
	PlayStretchSound()

func UpdateFlight() -> void:
	PlayCollisionSound()

func UpdateArrow() -> void:
	m_oArrow.rotation = (-1 * m_rsrsTotalDrag).angle()
	m_oArrow.scale.x = max(0.25,(m_rsrsTotalDrag.length() - 20)/120)
	# Let's do the math problem.
	# Radius of animal is 20.
	# Length of arrow is 120.
	# Want the arrow to end just in front of the animal.
	# Match the centers. LHS is desired distance to end of arrow plus half the scaled arrow,
	# RHS is where the scaled offset ends up.
	# So, 25 + 60 * scale = scale * offset
	# offset = 60 + 25/scale
	m_oArrow.offset.x = 60 + 25/m_oArrow.scale.x

func GetImpulse() -> Vector2:
	return m_rsrsTotalDrag * -10

# A clamp function for Vector2.
func ClampVector(a_rsrsVector: Vector2, 
				a_rsMinX: float, a_rsMinY: float,
				a_rsMaxX: float, a_rsMaxY: float) -> Vector2:	
	return Vector2(clamp(a_rsrsVector.x, a_rsMinX, a_rsMaxX), clamp(a_rsrsVector.y, a_rsMinY, a_rsMaxY))	

func PlayCollisionSound() -> void:
	if (m_uiLastCollisionCount == 0 and
		get_contact_count() > 0 and
		not m_oKickSound.playing):
		m_oKickSound.play()
		print("Kick sound played")
	m_uiLastCollisionCount = get_contact_count()

# Function to check whether or not we've released the animal.
func DetectRelease() -> bool:
	# We can only release it if it was previously in the dragged state.
	if m_iEnumAnimalState == TtlANIAnimalState.DRAG:
		if Input.is_action_just_released("drag") == true:
			SetNewState(TtlANIAnimalState.RELEASE)
			return true
	return false


# Plays the stretch sound audio clip if the audio clip isn't already playing
# and if we're moving the animal.
func PlayStretchSound() -> void:
	if (m_rsrsPreviousDrag - m_rsrsTotalDrag).length() > 0:
		if m_oStretchSound.playing == false:
			m_oStretchSound.play()
			print("Stretch sound played")


# What we do when the animal dies (such as by going offscreen).
func Die()->void:
	TtlANISignalManager.on_animal_died.emit()
	queue_free()


func _on_screen_exited():
	Die()


# Start the dragging process.
func StartDrag() -> void:
	if m_iEnumAnimalState == TtlANIAnimalState.READY:
		SetNewState(TtlANIAnimalState.DRAG)


func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("drag"):
		StartDrag()


func _on_sleeping_state_changed():
	if sleeping:
		var aoCollidingBodies = get_colliding_bodies()
		if aoCollidingBodies.size() > 0:
			if aoCollidingBodies[0].has_method("Die"):
				aoCollidingBodies[0].Die()
		call_deferred("Die")
