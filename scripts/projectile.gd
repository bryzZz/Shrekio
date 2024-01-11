class_name Projectile extends RigidBody2D

const breakParticle = preload("res://scenes/projectile_break_particle.tscn")

func _on_body_entered(body):
	if body.is_in_group('can_take_damage'):
		body.take_damage()
	
	var _particle = breakParticle.instantiate() as CPUParticles2D
	get_tree().current_scene.add_child(_particle)
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	
	queue_free()
