extends CharacterBody2D

@onready var sprite = $Sprite as Sprite2D
@onready var animation_player = $AnimationPlayer as AnimationPlayer

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	apply_graviry(delta)
	
	jump()
	walk()

	move_and_slide()

func walk():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction == 1:
		sprite.set_flip_h(false)
	if direction == -1:
		sprite.set_flip_h(true)

func jump():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation_player.play('jump')

func apply_graviry(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
