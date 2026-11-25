class_name SettlementData
extends Resource


enum SettlementName {EISENSTADT, SCHWARZWALD, DORNENFELD, KUPFERGRUB, GRAUHAFEN}
enum SettlementType {CAPITAL, LUMBERJACK, FARMING, MINER, FISHING}


# Properties
@export var settlement_name: SettlementName = SettlementName.EISENSTADT
@export var settlement_type: SettlementType = SettlementType.CAPITAL
@export var settlement_population: int = 0
