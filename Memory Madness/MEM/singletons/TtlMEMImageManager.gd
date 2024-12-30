extends Node

const s_szItemName = "m_szItemName"
const s_szItemTexture = "m_oItemTexture"

const s_oaoFrameImages: Array = [
	preload("res://MEM/assets/frames/green_frame.png"),
	preload("res://MEM/assets/frames/blue_frame.png"),
	preload("res://MEM/assets/frames/red_frame.png"),
	preload("res://MEM/assets/frames/yellow_frame.png")
]

var m_oaoItemImages: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	LoadItemImages()

func LoadImageFromFile(szFileName: String, szFileDir: String) -> void:
	var szFilePath = szFileDir + "/" + szFileName
	
	var oDictItem = {
		s_szItemName: szFileName.rstrip(".png"),
		s_szItemTexture: load(szFilePath)
	}
	
	m_oaoItemImages.append(oDictItem)

func LoadItemImages() -> void:
	
	var szGlitchDirPath = "res://MEM/assets/glitch"
	
	var oDirectoryGlitch = DirAccess.open(szGlitchDirPath)
	
	if not oDirectoryGlitch:
		print ("ERROR:", szGlitchDirPath)
		return
	
	var oaszFileNames = oDirectoryGlitch.get_files()
	
	for szFileName in oaszFileNames:
		if ".import" not in szFileName:
			LoadImageFromFile(szFileName, szGlitchDirPath)
	
	print ("loaded:", m_oaoItemImages.size())

func GetRandomItemImageDict() -> Dictionary:
	return m_oaoItemImages.pick_random()

func GetImage(a_iIndex: int) -> Dictionary:
	return m_oaoItemImages[a_iIndex]

func GetRandomFrameImage() -> CompressedTexture2D:
	return s_oaoFrameImages.pick_random()

func ShuffleImages() -> void:
	m_oaoItemImages.shuffle()
