extends Node

const s_szTileGroup: String = "tile"

const s_oDictLevels: Dictionary = {
	1: { "rows": 2, "cols": 2},
	2: { "rows": 3, "cols": 4},
	3: { "rows": 4, "cols": 4},
	4: { "rows": 4, "cols": 6},
	5: { "rows": 5, "cols": 6},
	6: { "rows": 6, "cols": 6},
}

func GetLevelSelection(a_iLevelNum: int) -> Dictionary:
	var oDictLevelData = s_oDictLevels[a_iLevelNum]
	var iNumTiles = oDictLevelData.rows * oDictLevelData.cols
	var iTargetPairs: int = iNumTiles/2
	var oaoSelectedLevelImages = []
	
	# Shuffle the list of images.
	TtlMEMImageManager.ShuffleImages()
	
	# We want n/2 distinct images, each of them
	# occuring exactly twice.
	for i in range(iTargetPairs):
		oaoSelectedLevelImages.append(TtlMEMImageManager.GetImage(i))
		oaoSelectedLevelImages.append(TtlMEMImageManager.GetImage(i))
	
	# Put those images in a random order.
	oaoSelectedLevelImages.shuffle()
	
	return {
		"m_iTargetPairs": iTargetPairs,
		"m_iNumCols": oDictLevelData.cols,
		"m_oaoImageList": oaoSelectedLevelImages
	}

func ClearNodesOfGroup(a_szGroupName: String) -> void:
	for oNode in get_tree().get_nodes_in_group(a_szGroupName):
		oNode.queue_free()
