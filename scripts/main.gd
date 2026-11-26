extends Node2D

# Exported variables
@export var goods_list: Array[GoodsData] = []
@export var settlements_list: Array[SettlementData] = []
# Public Variables
var goods: Dictionary = {}
var settlements: Dictionary = {}
var health: int = 100
var wallet: int = 100


# Onready variables
@onready var gold_label: Label = %GoldValue
@onready var silver_label: Label = %SilverValue
@onready var bronze_label: Label = %BronzeValue


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_goods()
	load_settlements()
	print("Health:", health)
	update_ui()

	# Running tests. They will be moved into debug scene
	Tests.run_calc_money_tests()
	Tests.run_item_tests()
	Tests.run_town_prices_tests()
	Tests.run_prices_tests()


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
		goods[res.item_name] = res.price


func load_settlements() -> void:
	for town in settlements_list:
		if town == null:
			push_error("Empty value in settlements_list")
			break
		if settlements.has(town.name):
			push_error("Duplicated value %s in settlements_list" % [town.name])
			break
		settlements[town.name] = town


func update_ui() -> void:
	var counted_money: Dictionary = Money.calc_money(wallet)
	bronze_label.text = str(counted_money["Bronze"])
	silver_label.text = str(counted_money["Silver"])
	gold_label.text = str(counted_money["Gold"])
