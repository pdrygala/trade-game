extends Node2D

var health: int = 100
var wallet: int = 100


# Onready variables
@onready var gold_label: Label = %GoldValue
@onready var silver_label: Label = %SilverValue
@onready var bronze_label: Label = %BronzeValue


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Health:", health)
	update_ui()

	# Running tests. They will be moved into debug scene
	Tests.verify_goods_data()
	Tests.verify_money_conversion()
	Tests.verify_price_calculations()
	Tests.verify_town_prices()
	Tests.verify_settlements_data()


func _on_button_pressed() -> void:
	wallet += 1
	update_ui()


func update_ui() -> void:
	var counted_money: Dictionary = Money.calc_money(wallet)
	bronze_label.text = str(counted_money["Bronze"])
	silver_label.text = str(counted_money["Silver"])
	gold_label.text = str(counted_money["Gold"])
