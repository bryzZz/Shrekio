class_name Wand extends Node2D

@onready var marker_2d = $Marker2D as Marker2D

const BULLET_VELOCITY = 1000.0
const ProjectileScene = preload("res://scenes/projectile.tscn")

func shoot(direction = 1.0):
	var projectile = ProjectileScene.instantiate() as Projectile
	projectile.global_position = marker_2d.global_position
	projectile.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0.0)
	projectile.set_as_top_level(true)
	add_child(projectile)
