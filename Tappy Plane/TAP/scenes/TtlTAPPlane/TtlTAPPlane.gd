extends CharacterBody2D

class_name TtlTAPPlane


# Instead of having this signal directly
# (as a lot of stuff needs to hear this signal),
# we route it through the SignalManager singleton.
# signal on_plane_died()


# Just an aside on layers and masks here.
# There are 32 layers in Godot, and every
# collision object needs to decide whether or not
# its layer and mask have each individual
# layer enabled.

# These layers can be named in project settings.
# Default seems to be everything belongs to layer 1
# and only layer 1.

# Anyway, the LAYER of a collision object
# determines which layers it belongs to.

# The MASK of a collision object determines
# which layers it will react to and emit on_collision
# style signals from.

# To give an example, suppose object A
# is on layer 3, and object B's mask detects layer 3.
# Then, when the two overlap, object B will emit
# its appropriate on_collision signal.
# Object A won't emit anything, UNLESS
# object B belongs to a layer inside
# object A's mask.

# Basically, if the masks and layers
# are asymmetric, you can have collisions
# that only one side notices.


# Gravity constant, adjustable.
const s_rsGravity: float = 1200.0
const s_rsFlight: float = -600.0

@onready var m_oAnimatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var m_oAnimationPlayer: AnimationPlayer = $AnimationPlayer
@onready var m_oEngineSound = $EngineSound


func _physics_process(delta):
	# Add the gravity.
	velocity.y += s_rsGravity * delta
	
	Fly()
	
	# Actually move the object.
	move_and_slide()
	
	# Have we collided with anything?
	if is_on_floor():
		PlaneCrash()

func Fly() -> void:
	if Input.is_action_just_pressed("Fly"):
		velocity.y = s_rsFlight
		m_oAnimationPlayer.play("power")

# What happens when the plane hits something.
func PlaneCrash() -> void:
	m_oEngineSound.stop()
	m_oAnimatedSprite2D.stop()
	set_physics_process(false)
	m_oAnimatedSprite2D.flip_v = true
	TtlTAPSignalManager.on_plane_died.emit()
