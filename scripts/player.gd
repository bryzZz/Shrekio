class_name Player extends CharacterBody2D

@onready var sprite = $Sprite as Sprite2D
@onready var animation_player = $AnimationPlayer as AnimationPlayer

const SPEED = 300.0
const JUMP_VELOCITY = -700.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_double_jump = true

func _physics_process(delta):
	apply_graviry(delta)
	
	jump()
	walk()

	move_and_slide()
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		var normal = collision.get_normal()
		if collider is Block and normal.y == 1:
			collider.on_hit()
		if collider is Enemy:
			if normal.y == -1:
				collider.on_hit()
			else:
				queue_free()

func walk():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction == 1:
		sprite.set_flip_h(false)
	if direction == -1:
		sprite.set_flip_h(true)

func jump():
	if not Input.is_action_just_pressed("up"):
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
