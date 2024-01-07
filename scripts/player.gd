class_name Player extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var camera_animation_player = $CameraAnimationPlayer as AnimationPlayer
@onready var camera_2d = $Camera2D as Camera2D
#@onready var wand = $Wand as Wand
@onready var marker_2d = $Marker2D as Marker2D
const BULLET_VELOCITY = 1000.0
const ProjectileScene = preload("res://scenes/projectile.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -700.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_move = true
var can_double_jump = true
var can_break_blocks = false
var is_attack = false

func _physics_process(delta):
	apply_graviry(delta)
	
	if not is_attack:
		if velocity.y < 0:
			sprite.play('jump')
		else:
			if velocity.x != 0:
				sprite.play('walk')
			else:
				sprite.play('default')
	
	jump()
	walk()
	try_shoot()

	move_and_slide()
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		var normal = collision.get_normal()
		if collider is Platform and normal.y == 1:
			collider.on_hit(collision, normal)
		if collider is Block and normal.y == 1:
			collider.on_hit(can_break_blocks)
		if collider is Enemy:
			if normal.y == -1:
				collider.on_hit()
			else:
				queue_free()
				get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func walk():
	if not can_move:
		return
	
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction == 1 and sprite.flip_h:
		sprite.set_flip_h(false)
		marker_2d.position.x = -1 * marker_2d.position.x
		marker_2d.rotation = -1 * marker_2d.rotation
	if direction == -1 and not sprite.flip_h:
		marker_2d.position.x = -1 * marker_2d.position.x
		marker_2d.rotation = -1 * marker_2d.rotation
		sprite.set_flip_h(true)

func jump():
	if not Input.is_action_just_pressed("up") or not can_move:
		return
	
	sprite.play('jump')
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		can_double_jump = true
	elif can_double_jump:
		velocity.y = JUMP_VELOCITY
		can_double_jump = false
#	animation_player.play('jump')

func try_shoot():
	if not Input.is_action_just_pressed("shoot"):
		return
	
	var direction = 1
	if sprite.flip_h:
		direction = -1
	shoot(direction)
	sprite.play('attack')
	is_attack = true
	await get_tree().create_timer(0.75).timeout
	is_attack = false

func shoot(direction = 1.0):
	var projectile = ProjectileScene.instantiate() as Projectile
	projectile.global_position = marker_2d.global_position
	projectile.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0.0)
	projectile.set_as_top_level(true)
	add_child(projectile)

func apply_graviry(delta):
	if not is_on_floor():
		velocity.y += gravity * 1.5 * delta


func hit_by_enemy():
	print('asd')

func collect_bonus():
#	camera_2d.zoom.x = 1.75
#	camera_2d.zoom.y = 1.75
	camera_animation_player.play('zoom_in')
	animation_player.play('collect_bonus')
	await get_tree().create_timer(0.2).timeout
	velocity.x = 0
	can_move = false
	can_break_blocks = true


func pickup_wand(wand):
	add_child(wand)
#	remove_child(wand)
#	move_child(wand, )
#	var scene = load("res://scenes/wand.tscn") as PackedScene



func angry_mode_end():
	animation_player.play_backwards('collect_bonus')
	can_break_blocks = false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'collect_bonus' and not can_move:
		camera_animation_player.play_backwards('zoom_in')
#		camera_2d.zoom.x = 1
#		camera_2d.zoom.y = 1
		can_move = true
		await get_tree().create_timer(5).timeout
		angry_mode_end()

