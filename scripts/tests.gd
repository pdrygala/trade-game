class_name Tests
extends RefCounted


static func run_prices_tests() -> void:
	Price.test_prices(1, 0.4, 1)
	Price.test_prices(10, 0.6, 6)
	Price.test_prices(12, 0.8, 10)


static func run_calc_money_tests() -> void:
	test_calc_money(0, {"Gold": 0, "Silver": 0, "Bronze": 0})
	test_calc_money(11, {"Gold": 0, "Silver": 0, "Bronze": 11})
	test_calc_money(12, {"Gold": 0, "Silver": 1, "Bronze": 0})
	test_calc_money(239, {"Gold": 0, "Silver": 19, "Bronze": 11})
	test_calc_money(240, {"Gold": 1, "Silver": 0, "Bronze": 0})
	test_calc_money(241, {"Gold": 1, "Silver": 0, "Bronze": 1})
	test_calc_money(5000, {"Gold": 20, "Silver": 16, "Bronze": 8})


static func run_item_tests() -> void:
	assert(not GameData.goods.is_empty(), "Goods dictionary should not be empty")
	for item in GameData.goods:
		var price: Variant = GameData.goods[item].price
		assert(item is String and not item.is_empty(), "Wrong item name")
		assert(price is int, "Wrong item price type for %s, int is expected" % item)
		assert(price > 0, "Price for an item %s should be bigger than 0" % item)


static func run_town_prices_tests() -> void:
	test_town_prices("Eisenstadt", "Grain", 11)
	test_town_prices("Dornenfeld", "Grain", 6)
	test_town_prices("Schwarzwald", "Wood", 7)
	test_town_prices("Kupfergrub", "Stone", 10)
	test_town_prices("Grauhafen", "Fish", 12)


static func test_town_prices(town: String, item: String, expected: int) -> void:
	var result: int = Price.local_price(town, item, GameData.settlements, GameData.goods)
	assert(
		expected == result,
		"Wrong %s price in %s, expected: %d given: %d" % [item, town, expected, result]
	)


static func test_calc_money(bronze_input: int, expected: Dictionary) -> void:
	var result: Dictionary = Money.calc_money(bronze_input)
	assert(
		result == expected,
		"Error while calculating money tests: Expected %s, Given %s" % [expected, result]
	)
