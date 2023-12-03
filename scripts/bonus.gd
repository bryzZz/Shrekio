class_name Bonus extends Area2D

@onready var collision_shape_2d = $CollisionShape2D as CollisionShape2D
@onready var animation_player = $AnimationPlayer as AnimationPlayer

func _on_body_entered(body):
	if body is Player:
		body.collect_bonus()
		collision_shape_2d.disabled = true
		animation_player.play('collect')


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'collect':
		queue_free()
