class_name Player extends CharacterBody2D

@onready var sprite = $Sprite as Sprite2D
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var camera_2d = $Camera2D as Camera2D
@onready var wand = $Wand as Wand

const SPEED = 300.0
const JUMP_VELOCITY = -700.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_move = true
var can_double_jump = true
var can_break_blocks = false

func _physics_process(delta):
	apply_graviry(delta)
	
	jump()
	walk()
	
	if Input.is_action_just_pressed("shoot"):
		var direction = 1
		if sprite.flip_h:
			direction = -1
		wand.shoot(direction)

	move_and_slide()
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		var normal = collision.get_normal()
		if collider is Block and normal.y == 1:
			collider.on_hit(can_break_blocks)
		if collider is Enemy:
			if normal.y == -1:
				collider.on_hit()
			else:
				queue_free()

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
		wand.position.x = -1 * wand.position.x
		wand.rotation = -1 * wand.rotation
	if direction == -1 and not sprite.flip_h:
		wand.position.x = -1 * wand.position.x
		wand.rotation = -1 * wand.rotation
		sprite.set_flip_h(true)

func jump():
	if not Input.is_action_just_pressed("up") or not can_move:
		return
	
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		can_double_jump = true
	elif can_double_jump:
		velocity.y = JUMP_VELOCITY
		can_double_jump = false
#	animation_player.play('jump')

func apply_graviry(delta):
	if not is_on_floor():
		velocity.y += gravity * 1.5 * delta


func hit_by_enemy():
	print('asd')

func collect_bonus():
	camera_2d.zoom.x = 1.75
	camera_2d.zoom.y = 1.75
	camera_2d.position.y = 0
	camera_2d.limit_top = -2000
	camera_2d.limit_bottom = 2000
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
		camera_2d.zoom.x = 1
		camera_2d.zoom.y = 1
		camera_2d.position.y = -60
		camera_2d.limit_top = 0
		camera_2d.limit_bottom = 0
		can_move = true
		await get_tree().create_timer(5).timeout
		angry_mode_end()





