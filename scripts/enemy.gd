class_name Enemy

extends CharacterBody2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var wall_detector_right = $WallDetectorRight as RayCast2D
@onready var wall_detector_left = $WallDetectorLeft as RayCast2D
@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var direction = -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	apply_graviry(delta)
	
	velocity.x = direction * SPEED
	
	animated_sprite_2d.play('default')
	
#	if is_on_wall():
#		print('here', direction)
##		velocity.x = -velocity.x
#		direction = -1 * direction
#
	if wall_detector_right.is_colliding():
		direction = -1

	if wall_detector_left.is_colliding():
		direction = 1
	
	if direction == 1 and animated_sprite_2d.flip_h:
		animated_sprite_2d.set_flip_h(false)
	if direction == -1 and not animated_sprite_2d.flip_h:
		animated_sprite_2d.set_flip_h(true)

#	if velocity.x > 0.0:
#		sprite.scale.x = 1.0
#	elif velocity.x < 0.0:
#		sprite.scale.x = -1.0
	
	move_and_slide()

func apply_graviry(delta):
	if not is_on_floor():
		velocity.y += gravity * 1.5 * delta

func on_hit():
	collision_shape_2d.disabled = true
	animation_player.play('die')


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'die':
		queue_free()
