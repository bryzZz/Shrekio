extends Path2D

@export var loop = true
@export var speed = 2.0
@export var speed_scale = 1.0

@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var path_follow_2d = $PathFollow2D as PathFollow2D


func _ready():
	if not loop:
		animation_player.play('move')
		animation_player.speed_scale = speed_scale
		set_process(false)


func _process(delta):
	path_follow_2d.progress += speed
