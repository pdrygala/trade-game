extends Node2D

# Variables
@onready var gold_label = %GoldValue
var health: int = 100
var gold: int = 100

var goods = {
	# Basic goods
	"Grain": 10,
	"Wood": 10,
	"Stone": 12,
	"Clay": 12,
	"Wool": 14,
	"Fish": 15
	}
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
	print("Health:", health)
	print("Gold:", gold)
	update_ui()
	test_item()
	test_town_prices()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	gold += 10
	update_ui()


func update_ui() -> void:
	gold_label.text = str(gold)


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
