extends Node



const s_oszGroupPlayer: String = "player"

# preload loads at compile time.
# load loads in when you actually need it.
# preload is smoother due to no load time,
# but you risk memory issues if you try it with large scenes.
var s_oSceneGame: PackedScene = preload("res://TAP/scenes/TtlTAPGame/TtlTAPGame.tscn")
var s_oSceneMain: PackedScene = preload("res://TAP/scenes/TtlTAPMainMenu/TtlTAPMainMenu.tscn")

const s_rsScrollSpeed: float = 120

# I don't initialize it here because it turns out,
# the autoload singletons only ever get initialized once!
# Relying on this initialization would work for the plane's
# first life and never again.
var m_rfGameRunning: bool

func LoadGameScene() -> void:
	get_tree().change_scene_to_packed(s_oSceneGame)

func LoadMainScene() -> void:
	get_tree().change_scene_to_packed(s_oSceneMain)
