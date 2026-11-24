extends Node2D
# Preload resources
@export var goods_list: Array[GoodsData] = []


var goods: Dictionary = {}
# Variables
@onready var gold_label = %GoldValue
@onready var silver_label = %SilverValue
@onready var bronze_label = %BronzeValue
var health: int = 100

var wallet: Money =Money.new(100)
var towns = {
	"Eisenstadt": "Capital",
	"Schwarzwald": "Lumberjacks' Settlement",
	"Dornenfeld": "Farming Village",
	"Kupfergrube": "Miners' Settlement",
	"Grauhafen": "Fishing Settlement"
}

var town_modifiers: Dictionary = {
	"Capital": {
		"Grain": 1.1,
		"Wood": 1.1,
		"Stone": 1.1,
		"Clay": 1.1,
		"Wool": 1.1,
		"Fish": 1.1
	},
	"Lumberjacks' Settlement": {
		"Wood": 0.7,
		"Stone": 1.1,
		"Wool": 1.1,
		"Fish": 1.1
	},
	"Farming Village": {
		"Grain": 0.6,
		"Wood": 1.2,
		"Stone": 1.2
	},
	"Miners' Settlement": {
		"Grain": 1.2,
		"Wood": 1.2,
		"Stone": 0.8,
		"Clay": 0.9,
		"Wool": 1.2,
		"Fish": 1.2
	},
	"Fishing Settlement": {
		"Wood": 1.2,
		"Wool": 1.2,
		"Fish": 0.8
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	load_goods()
	print("Health:", health)
		
	run_calc_money_tests()
	update_ui()
	run_item_tests()
	test_town_prices()


func load_goods() -> void:
	for res in goods_list:
		if res == null:
			continue
		var key: String = res.get("item_name")
		goods[key] = res.price


func _on_button_pressed() -> void:
	wallet.wallet += 1
	update_ui()


func update_ui() -> void:
	var counted_money: Dictionary = Money.calc_money(wallet.wallet)
	bronze_label.text = str(counted_money["Bronze"])
	silver_label.text = str(counted_money["Silver"])
	gold_label.text = str(counted_money["Gold"])


func local_price(town: String, item: String) -> float:
	var price: float
	var towntype: String
	
	# Checking if town exist
	if not towns.has(town):
		push_error("There is no such city: ", str(town))
		return 0
	towntype = towns[town]
	
	# Checking if item exits
	if not goods.has(item):
		push_error("There is no such item: ", str(item))
		return 0
	
	price = goods[item] * town_modifiers[towntype].get(item, 1.0)
	return price
		

func run_item_tests() -> void:
	assert(not goods.is_empty(), "Goods dictionary should not be empty")
	for item in goods:
		var price: Variant = goods[item]
		assert(item is String and not item.is_empty(), "Wrong item name")
		assert(price is int, "Wrong item price type for %s, int is expected" % item)
		assert(price > 0, "Price for an item %s should be bigger than 0" % item)


func test_town_prices() -> void:
	for town in towns:
		for item in goods:
			print(town, " price of ", item, ": ", local_price(town, item))


func run_calc_money_tests() -> void:
	Money.test_calc_money(0, {"Gold": 0, "Silver": 0, "Bronze": 0})
	Money.test_calc_money(11, {"Gold": 0, "Silver": 0, "Bronze": 11})
	Money.test_calc_money(12, {"Gold": 0, "Silver": 1, "Bronze": 0})
	Money.test_calc_money(239, {"Gold": 0, "Silver": 19, "Bronze": 11})
	Money.test_calc_money(240, {"Gold": 1, "Silver": 0, "Bronze": 0})
	Money.test_calc_money(241, {"Gold": 1, "Silver": 0, "Bronze": 1})
	Money.test_calc_money(5000, {"Gold": 20, "Silver": 16, "Bronze": 8})
