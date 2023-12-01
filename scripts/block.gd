class_name Block

extends StaticBody2D

@export var coint_amount = 1

@onready var collision_shape_2d = $CollisionShape2D as CollisionShape2D
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var animation_player2 = $AnimationPlayer2 as AnimationPlayer


func on_hit():
	animation_player.play('hit')
	
	if coint_amount > 0:
		animation_player2.play('coin')
		coint_amount -= 1
#		print(get_tree().current_scene.get_node('UI'))
		get_tree().current_scene.get_node('UI').collect_coin()
