extends Control

var screen_size: Vector2
@onready var node = $Control as Control

func _ready():
	screen_size = get_viewport_rect().size
	
func _process(delta):
	var tween = node.create_tween()
	var offsetX = (get_global_mouse_position().x / screen_size.x) * 30
	var offset = Vector2(offsetX, 0)
	tween.tween_property(node, "position", offset, 1.0)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_exit_pressed():
	get_tree().quit()

