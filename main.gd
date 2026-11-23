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
@onready var gold_label = $GoldLabel/GoldValue
@onready var silver_label = $SilverLabel/SilverValue
@onready var bronze_label = $BronzeLabel/BronzeValue
var health: int = 100

# Money variables
var wallet: int = 100
const bronze_to_silver: int = 12
const bronze_to_gold: int = 240


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
	# Checking imported resources and setting dictionary for it
	print(clay.item_name)
	print(wood)
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
	@warning_ignore("integer_division")
	var b: int = wallet
	@warning_ignore("integer_division")
	var g: int = wallet/bronze_to_gold
	b %= bronze_to_gold
	@warning_ignore("integer_division")
	var s: int = b/bronze_to_silver	
	b %= bronze_to_silver	
	bronze_label.text = str(b)
	silver_label.text = str(s)
	gold_label.text = str(g)


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
		print(item,": ", goods[item], " zł")


func test_town_prices() -> void:
	for town in towns:
		for item in goods:
			print(town, " price of ", item, ": ", local_price(town,item))


func print_money(b: int) -> void:
	@warning_ignore("integer_division")
	var g: int = b/bronze_to_gold
	b %= bronze_to_gold
	@warning_ignore("integer_division")
	var s: int = b/bronze_to_silver
	b %= bronze_to_silver
	print("Gold: ",g,"g, Silver: ",s,"s, Bronze: ",b, "b")
	
