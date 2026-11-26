class_name GoodData
extends Node

var goods_list: Array[GoodsData] = []
var settlements_list: Array[SettlementData] = []
var goods: Dictionary = {}
var settlements: Dictionary = {}

const GOODS_DIR: String = "res://data/goods/"
const SETTLEMENTS_DIR: String = "res://data/settlements/"

static func load_resources(path: String, resource: Dictionary) -> void:
	var dir = DirAccess.open(path)
	if not dir:
		push_error("The folder %s could not be opened" % [path])
		return

	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			var full_path: String = path.path_join(file_name)
			var res: Resource = load(full_path)
			if not res:
				var key: String = file_name.get_basename().to_pascal_case()
				resource[key] = res
		file_name = dir.get_next()
	dir.list_dir_end()
