extends Node2D


const s_oSceneAnimal = preload("res://ANI/scenes/TtlANIAnimal/TtlANIAnimal.tscn")


@onready var m_oAnimalStart = $AnimalStart

var m_oAnimal = null

# Called when the node enters the scene tree for the first time.
func _ready():
	TtlANISignalManager.on_animal_died.connect(_on_animal_died)
	SpawnAnimal()

func SpawnAnimal() -> void:
	m_oAnimal = s_oSceneAnimal.instantiate()
	m_oAnimal.position = m_oAnimalStart.position
	add_child(m_oAnimal)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_animal_died():
	SpawnAnimal()
