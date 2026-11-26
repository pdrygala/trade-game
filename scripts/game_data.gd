extends Node

const GOODS_DIR: String = "res://data/goods/"
const SETTLEMENTS_DIR: String = "res://data/settlements/"

var goods_list: Array[GoodsData] = []
var settlements_list: Array[SettlementData] = []
var goods: Dictionary = {}
var settlements: Dictionary = {}


func _ready() -> void:
	load_resources(GOODS_DIR, goods_list)
	load_resources(SETTLEMENTS_DIR, settlements_list)
	load_goods()
	load_settlements()


static func load_resources(path: String, list: Array) -> void:
	var dir: DirAccess = DirAccess.open(path)
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
				push_error("Failed to load resource at: %s" % [full_path])
				return
			list.append(res)
		file_name = dir.get_next()
	dir.list_dir_end()


func load_goods() -> void:
	for res in goods_list:
		if res == null:
			push_error("Empty value in goods_list")
			break
		if goods.has(res.item_name):
			push_error("Duplicated value %s in goods_list" % [res.item_name])
			break
		goods[res.item_name] = res


func load_settlements() -> void:
	for town in settlements_list:
		if town == null:
			push_error("Empty value in settlements_list")
			break
		if settlements.has(town.name):
			push_error("Duplicated value %s in settlements_list" % [town.name])
			break
		settlements[town.name] = town
