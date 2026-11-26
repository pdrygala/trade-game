class_name Price
extends RefCounted


const town_modifiers: Dictionary = {
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


static func calc_price(price: int, modifier: float) -> int:
	var result: float = price * modifier
	return maxi(roundi(result), 1)


static func local_price(town: String, item: String, settlements: Dictionary, goods: Dictionary) -> int:
	# Checking if town exists
	if not settlements.has(town):
		push_error("There is no such city: %s" % [town])
		return 0
	var towntype: SettlementData.SettlementType = settlements[town].type

	# Checking if item exists
	if not goods.has(item):
		push_error("There is no such item: %s" % [item])
		return 0

	return calc_price(goods[item], town_modifiers[towntype].get(item, 1.0))


static func test_prices(base_price: int, modifier: float, expected: int) -> void:
	var result: int = Price.calc_price(base_price, modifier)
	assert(
		expected == result,
		"Wrong calculated price, for price %d and modifier %f expected: %d given: %d" % [base_price, modifier, expected, result]
	)
