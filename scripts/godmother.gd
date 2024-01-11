extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player: Player = null
var fly_delay = false
var move_to_player = true
const BULLET_VELOCITY = 500.0
@export var health = 5

@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var wand_marker = $Marker2D as Marker2D
@onready var shoot_timer = $ShootTimer as Timer
@onready var animation_player = $AnimationPlayer as AnimationPlayer
const ProjectileScene = preload("res://scenes/projectile.tscn")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	sprite.play('idle')
	
	if player:
		var direction = 1 if player.position.x > position.x else -1
		if move_to_player:
			velocity.x = direction * SPEED
		else:
			velocity.x = direction * SPEED * -1
#			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		try_fly()
		
		if direction == 1 and sprite.flip_h:
			sprite.set_flip_h(false)
			wand_marker.position.x = -1 * wand_marker.position.x
		elif direction == -1 and not sprite.flip_h:
			wand_marker.position.x = -1 * wand_marker.position.x
			sprite.set_flip_h(true)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func try_fly():
	if player.global_position.y - 150 < global_position.y and not fly_delay:
		velocity.y = JUMP_VELOCITY
		fly_delay = true
		await get_tree().create_timer(0.4).timeout
		fly_delay = false

func take_damage():
	health -= 1
	animation_player.play('damage')
	
	if health == 0:
		get_tree().current_scene.get_node('UI').collect_coin(10)
		queue_free()

func _on_player_detector_body_entered(body):
	if body is Player:
		player = body
		shoot_timer.start()

func _on_player_detector_body_exited(body):
	if body is Player:
		player = null
		shoot_timer.stop()

func _on_player_detector_2_body_entered(body):
	if body is Player:
		move_to_player = false

func _on_player_detector_2_body_exited(body):
	if body is Player:
		move_to_player = true

func _on_shoot_timer_timeout():
	var direction = -1 if sprite.flip_h else 1
	var projectile = ProjectileScene.instantiate() as Projectile
	projectile.global_position = wand_marker.global_position
	projectile.linear_velocity = Vector2(direction * BULLET_VELOCITY, 200.0)
	projectile.set_as_top_level(true)
	add_child(projectile)



















