class_name Price
extends RefCounted


const TOWN_MODIFIERS: Dictionary = {
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


static func local_price(town: String, item: String) -> int:
	# Checking if town exists
	if not GameData.settlements.has(town):
		push_error("There is no such city: %s" % [town])
		return 0
	var towntype: SettlementData.SettlementType = GameData.settlements[town].type

	# Checking if item exists
	if not GameData.goods.has(item):
		push_error("There is no such item: %s" % [item])
		return 0

	return calc_price(GameData.goods[item].price, TOWN_MODIFIERS[towntype].get(item, 1.0))
