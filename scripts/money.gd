class_name Money
extends RefCounted

# Money consts
const SILVER_TO_BRONZE: int = 12
const GOLD_TO_BRONZE: int = 240

# Properties
var wallet: int = 0

func _init(bronze: int = 0) -> void:
	wallet = bronze


static func calc_money(bronze_input: int) -> Dictionary:
	var bronze: int = bronze_input
	var dict_money: Dictionary = {}
	
	@warning_ignore("integer_division")
	var gold: int = bronze / GOLD_TO_BRONZE
	bronze %= GOLD_TO_BRONZE
	@warning_ignore("integer_division")
	var silver: int = bronze / SILVER_TO_BRONZE
	bronze %= SILVER_TO_BRONZE
	dict_money["Gold"] = gold
	dict_money["Silver"] = silver
	dict_money["Bronze"] = bronze
	return dict_money


static func test_calc_money(bronze_input: int, expected: Dictionary) -> void:
	var result: Dictionary = calc_money(bronze_input)
	assert(
		result == expected,
		"Error while calculating money tests: Expected %s, Given %s" % [expected, result]
	)
