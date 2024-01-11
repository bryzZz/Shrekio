extends Area2D

#@onready var animation_player = $AnimationPlayer as AnimationPlayer
#
#func _ready():
#	animation_player.play('idle')

func _on_body_entered(body):
	if not (body is Player):
		return
	
	queue_free()
	body.pickup_wand()
