extends Node2D

# Exported variables
@export var goods_list: Array[GoodsData] = []
@export var settlements_list: Array[SettlementData] = []
# Public Variables
var goods: Dictionary = {}
var settlements: Dictionary = {}
var health: int = 100
var wallet: int = 100


var town_modifiers: Dictionary = {
	SettlementData.SettlementType.CAPITAL: {
		"Grain": 1.1,
		"Wood": 1.1,
		"Stone": 1.1,
		"Clay": 1.1,
		"Wool": 1.1,
		"Fish": 1.1
	},
	SettlementData.SettlementType.LUMBERJACK: {
		"Wood": 0.7,
		"Stone": 1.1,
		"Wool": 1.1,
		"Fish": 1.1
	},
	SettlementData.SettlementType.FARMING: {
		"Grain": 0.6,
		"Wood": 1.2,
		"Stone": 1.2
	},
	SettlementData.SettlementType.MINER: {
		"Grain": 1.2,
		"Wood": 1.2,
		"Stone": 0.8,
		"Clay": 0.9,
		"Wool": 1.2,
		"Fish": 1.2
	},
	SettlementData.SettlementType.FISHING: {
		"Wood": 1.2,
		"Wool": 1.2,
		"Fish": 0.8
	}
}

# Onready variables
@onready var gold_label: Label = %GoldValue
@onready var silver_label: Label = %SilverValue
@onready var bronze_label: Label = %BronzeValue


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_goods()
	load_settlements()
	print("Health:", health)
#	print(settlements[])
	run_calc_money_tests()
	update_ui()
	run_item_tests()
	#test_town_prices()


func _on_button_pressed() -> void:
	wallet += 1
	update_ui()


func load_goods() -> void:
	for res in goods_list:
		if res == null:
			push_error("Empty value in goods_list")
			break
		if goods.has(res.item_name):
			push_error("Duplicated value %s in goods_list" % [res.item_name])
			break
		var key: String = res.item_name
		goods[key] = res.price


func load_settlements() -> void:
	for town in settlements_list:
		if town == null:
			push_error("Empty value in settlements_list")
			break
		if settlements.has(town.SettlementName):
			push_error("Duplicated value %s in settlements_list" % [town.SettlementName])
			break
		settlements[town.SettlementName] = town


func update_ui() -> void:
	var counted_money: Dictionary = Money.calc_money(wallet)
	bronze_label.text = str(counted_money["Bronze"])
	silver_label.text = str(counted_money["Silver"])
	gold_label.text = str(counted_money["Gold"])


#func local_price(town: String, item: String) -> float:
	## Checking if town exist
	#if not towns.has(town):
		#push_error("There is no such city: ", str(town))
		#return 0
	#var towntype: String = towns[town]
#
	## Checking if item exists
	#if not goods.has(item):
		#push_error("There is no such item: ", str(item))
		#return 0
#
	#var price: float = goods[item] * town_modifiers[towntype].get(item, 1.0)
	#return price
#

func run_item_tests() -> void:
	assert(not goods.is_empty(), "Goods dictionary should not be empty")
	for item in goods:
		var price: Variant = goods[item]
		assert(item is String and not item.is_empty(), "Wrong item name")
		assert(price is int, "Wrong item price type for %s, int is expected" % item)
		assert(price > 0, "Price for an item %s should be bigger than 0" % item)


# This function need to be rewritten into proper test function
#func test_town_prices() -> void:
	#for town in towns:
		#for item in goods:
			#print(town, " price of ", item, ": ", local_price(town, item))


func run_calc_money_tests() -> void:
	Money.test_calc_money(0, {"Gold": 0, "Silver": 0, "Bronze": 0})
	Money.test_calc_money(11, {"Gold": 0, "Silver": 0, "Bronze": 11})
	Money.test_calc_money(12, {"Gold": 0, "Silver": 1, "Bronze": 0})
	Money.test_calc_money(239, {"Gold": 0, "Silver": 19, "Bronze": 11})
	Money.test_calc_money(240, {"Gold": 1, "Silver": 0, "Bronze": 0})
	Money.test_calc_money(241, {"Gold": 1, "Silver": 0, "Bronze": 1})
	Money.test_calc_money(5000, {"Gold": 20, "Silver": 16, "Bronze": 8})
