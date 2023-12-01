class_name Enemy

extends CharacterBody2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var wall_detector_right = $WallDetectorRight as RayCast2D
@onready var wall_detector_left = $WallDetectorLeft as RayCast2D
@onready var sprite = $Icon as Sprite2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var direction = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	apply_graviry(delta)
	
	velocity.x = direction * SPEED
	
#	if is_on_wall():
#		print('here', direction)
##		velocity.x = -velocity.x
#		direction = -1 * direction
#
	if wall_detector_right.is_colliding():
		direction = -1

	if wall_detector_left.is_colliding():
		direction = 1

#	if velocity.x > 0.0:
#		sprite.scale.x = 1.0
#	elif velocity.x < 0.0:
#		sprite.scale.x = -1.0
	
	move_and_slide()
#	var collision = get_last_slide_collision()
#	if collision:
#		var normal = collision.get_normal()
#		if normal.x == -1 and direction == 1:
#			direction = -1
#		if normal.x == 1 and direction == -1:
#			direction = 1


func apply_graviry(delta):
	if not is_on_floor():
		velocity.y += gravity * 1.5 * delta

func on_hit():
	collision_shape_2d.disabled = true
	animation_player.play('die')


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'die':
		queue_free()
