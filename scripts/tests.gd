class_name Tests
extends RefCounted


static func verify_settlements_data() -> void:
	assert(not GameData.settlements.is_empty(),"Settlements dictionary should not be empty")
	for town in GameData.settlements:
		assert(town is String and not town.is_empty(), "Wrong town name for %s" % [town])
		assert(GameData.settlements[town].population > 0, "Population for town %s should be bigger than 0" % [town])
		assert(Price.TOWN_MODIFIERS.has(GameData.settlements[town].type), "Town type for %s is not specified in TOWNMODIFIERS dictionary" % [town]) #typ osady ma wpis w tabeli modyfikatorów


static func verify_price_calculations() -> void:
	_check_calculated_price(1, 0.4, 1)
	_check_calculated_price(10, 0.6, 6)
	_check_calculated_price(12, 0.8, 10)


static func verify_money_conversion() -> void:
	_check_money_breakdown(0, {"Gold": 0, "Silver": 0, "Bronze": 0})
	_check_money_breakdown(11, {"Gold": 0, "Silver": 0, "Bronze": 11})
	_check_money_breakdown(12, {"Gold": 0, "Silver": 1, "Bronze": 0})
	_check_money_breakdown(239, {"Gold": 0, "Silver": 19, "Bronze": 11})
	_check_money_breakdown(240, {"Gold": 1, "Silver": 0, "Bronze": 0})
	_check_money_breakdown(241, {"Gold": 1, "Silver": 0, "Bronze": 1})
	_check_money_breakdown(5000, {"Gold": 20, "Silver": 16, "Bronze": 8})


static func verify_goods_data() -> void:
	assert(not GameData.goods.is_empty(), "Goods dictionary should not be empty")
	for item in GameData.goods:
		var price: Variant = GameData.goods[item].price
		assert(item is String and not item.is_empty(), "Wrong item name")
		assert(price is int, "Wrong item price type for %s, int is expected" % item)
		assert(price > 0, "Price for an item %s should be bigger than 0" % item)


static func verify_town_prices() -> void:
	_check_town_item_price("Eisenstadt", "Grain", 11)
	_check_town_item_price("Dornenfeld", "Grain", 6)
	_check_town_item_price("Schwarzwald", "Wood", 7)
	_check_town_item_price("Kupfergrub", "Stone", 10)
	_check_town_item_price("Grauhafen", "Fish", 12)


static func _check_town_item_price(town: String, item: String, expected: int) -> void:
	var result: int = Price.local_price(town, item)
	assert(
		expected == result,
		"Wrong %s price in %s, expected: %d given: %d" % [item, town, expected, result]
	)


static func _check_money_breakdown(bronze_input: int, expected: Dictionary) -> void:
	var result: Dictionary = Money.calc_money(bronze_input)
	assert(
		result == expected,
		"Error while calculating money tests: Expected %s, Given %s" % [expected, result]
	)


static func _check_calculated_price(base_price: int, modifier: float, expected: int) -> void:
	var result: int = Price.calc_price(base_price, modifier)
	assert(
		expected == result,
		"Wrong calculated price, for price %d and modifier %f expected: %d given: %d" % [base_price, modifier, expected, result]
	)
