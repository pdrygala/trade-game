class_name SettlementData
extends Resource


enum SettlementType {CAPITAL, LUMBERJACK, FARMING, MINER, FISHING}


# Properties
@export var name: String = ""
@export var type: SettlementType = SettlementType.CAPITAL
@export var population: int = 0
