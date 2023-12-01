class_name UI extends CanvasLayer

var coins_collected = 0

@onready var coins_label = $MarginContainer/HBoxContainer/Label as Label

func _ready():
	coins_label.set_text('Coins: ' + str(coins_collected))

func collect_coin():
	coins_collected += 1
	coins_label.set_text('Coins: ' + str(coins_collected))
