extends Node

const s_szSoundMainMenu = "main"
const s_szSoundInGame = "ingame"
const s_szSoundSuccess = "success"
const s_szSoundGameOver = "gameover"
const s_szSoundSelectTile = "tile"
const s_szSoundSelectButton = "button"

const s_oDictSounds = {
	s_szSoundMainMenu: preload("res://MEM/assets/sounds/bgm_action_3.mp3"),
	s_szSoundInGame: preload("res://MEM/assets/sounds/bgm_action_4.mp3"),
	s_szSoundSuccess: preload("res://MEM/assets/sounds/sfx_sounds_fanfare3.wav"),
	s_szSoundGameOver: preload("res://MEM/assets/sounds/sfx_sounds_powerup12.wav"),
	s_szSoundSelectTile: preload("res://MEM/assets/sounds/sfx_sounds_impact1.wav"),
	s_szSoundSelectButton: preload("res://MEM/assets/sounds/sfx_sounds_impact7.wav")
}

func PlaySound(a_oPlayer: AudioStreamPlayer, a_szKey: String) -> void:
	if !s_oDictSounds.has(a_szKey):
		return
	a_oPlayer.stop()
	a_oPlayer.stream = s_oDictSounds[a_szKey]
	a_oPlayer.play()

func PlayButtonClick(a_oPlayer: AudioStreamPlayer) -> void:
		PlaySound(a_oPlayer, s_szSoundSelectButton)

func PlayTileClick(a_oPlayer: AudioStreamPlayer) -> void:
		PlaySound(a_oPlayer, s_szSoundSelectTile)
