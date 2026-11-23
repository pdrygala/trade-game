extends Node2D

# Preload resources
var clay = preload("res://data/goods/Clay.tres")
var fish = preload("res://data/goods/Fish.tres")
var grain = preload("res://data/goods/Grain.tres")
var stone = preload("res://data/goods/Stone.tres")
var wood = preload("res://data/goods/Wood.tres")
var wool = preload("res://data/goods/Wool.tres")

var goods: Dictionary = {}
# Variables
@onready var gold_label = %GoldValue
@onready var silver_label = %SilverValue
@onready var bronze_label = %BronzeValue
var health: int = 100

# Money variables
var wallet: int = 100
const bronze_to_silver: int = 12
const bronze_to_gold: int = 240

var counted_money: Dictionary = {}

var towns = {
	"Eisenstadt":"Capital",
	"Schwarzwald":"Lumberjacks' Settlement",
	"Dornenfeld":"Farming Village",
	"Kupfergrube":"Miners' Settlement",
	"Grauhafen":"Fishing Settlement"
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
	goods[clay.item_name] = clay.price
	goods[fish.item_name] = fish.price
	goods[grain.item_name] = grain.price
	goods[stone.item_name] = stone.price
	goods[wood.item_name] = wood.price
	goods[wool.item_name] = wool.price
	
	print("Health:", health)
	print_money(wallet)
	update_ui()
	test_item()
	test_town_prices()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	wallet += 1
	update_ui()


func update_ui() -> void:
	counted_money= calc_money(wallet,counted_money)
	if not counted_money.has("Gold") or not counted_money.has("Silver") or not counted_money.has("Bronze"):
		push_error("Error after calculating money")
		pass
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
	
	price = goods[item] * town_modifiers[towntype].get(item,1.0)
	return price
		

func test_item() -> void:
	for item in goods:
		print(item,": ", goods[item], " b")


func test_town_prices() -> void:
	for town in towns:
		for item in goods:
			print(town, " price of ", item, ": ", local_price(town,item))


func print_money(b: int) -> void:
	counted_money= calc_money(b,counted_money)
	print("Gold: ",counted_money["Gold"],"g, Silver: ",counted_money["Silver"],"s, Bronze: ",counted_money["Bronze"], "b")
	


func calc_money (bronze: int, dict: Dictionary) -> Dictionary:
	@warning_ignore("integer_division")
	var gold: int = bronze/bronze_to_gold
	bronze %= bronze_to_gold
	@warning_ignore("integer_division")
	var silver: int = bronze/bronze_to_silver
	bronze %= bronze_to_silver
	dict["Gold"] = gold
	dict["Silver"] = silver
	dict["Bronze"] = bronze
	return dict
