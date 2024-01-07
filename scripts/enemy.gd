class_name Enemy

extends CharacterBody2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var animation_player = $AnimationPlayer
@onready var wall_detector_right = $WallDetectorRight as RayCast2D
@onready var wall_detector_left = $WallDetectorLeft as RayCast2D
@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D
@onready var floor_detector_right = $FloorDetectorRight as RayCast2D
@onready var floor_detector_left = $FloorDetectorLeft as RayCast2D

@export var SPEED = 200.0
@export var direction = -1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	animated_sprite_2d.play('default')

func _physics_process(delta):
	apply_forces(delta)
	try_turn_around()
	move_and_slide()

func try_turn_around():
	if wall_detector_right.is_colliding() or (is_on_floor() and not floor_detector_right.is_colliding()):
		direction = -1
	elif wall_detector_left.is_colliding() or (is_on_floor() and not floor_detector_left.is_colliding()):
		direction = 1
	
	if direction == 1:
		animated_sprite_2d.set_flip_h(true)
	else:
		animated_sprite_2d.set_flip_h(false)
	

func apply_forces(delta):
	if not is_on_floor():
		velocity.y += gravity * 1.5 * delta
	else:
		velocity.x = direction * SPEED

func on_hit():
	collision_shape_2d.disabled = true
	animation_player.play('die')


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'die':
		queue_free()
