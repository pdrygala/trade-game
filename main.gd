extends Node2D

#Variables
var health: int
var gold: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 100
	gold = 100
	print("Health:",health)
	print("Gold:", gold)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$GoldLabel/GoldValue
	$%GoldValue.text = var_to_str(gold)


func _on_button_pressed() -> void:
	gold += 10
