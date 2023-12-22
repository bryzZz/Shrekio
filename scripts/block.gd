@tool
class_name Block

extends StaticBody2D

@onready var collision_shape_2d = $CollisionShape2D as CollisionShape2D
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var animation_player2 = $AnimationPlayer2 as AnimationPlayer
@onready var logs: Array[Sprite2D] = [$Log1, $Log2, $Log3, $Log4]

@export var coint_amount = 1
@export var breakParticle: PackedScene
@export var texture: Texture2D = preload("res://assets/log/log1.png"):
	set(new_texture):
		texture = new_texture
		($Sprite2D as Sprite2D).set_texture(texture)
	

func on_hit(break_me: bool):
	if break_me:
		on_break()
		return
 
	animation_player.play('hit')
	
	if coint_amount > 0:
		animation_player2.play('coin')
		coint_amount -= 1
		get_tree().current_scene.get_node('UI').collect_coin()

func on_break():
	var _particle = breakParticle.instantiate() as CPUParticles2D
	get_tree().current_scene.add_child(_particle)
	_particle.position = global_position
	_particle.rotation = global_rotation
	_particle.emitting = true
	
	queue_free()



