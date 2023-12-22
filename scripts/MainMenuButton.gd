extends TextureButton

func change_scale(new_scale: Vector2):
	var button_size = get_size()
	var button_pos = global_position
	
	global_position += (button_size * scale) / 2 - (button_size * new_scale) / 2
	set_scale(new_scale)

func _on_mouse_entered():
	change_scale(Vector2(1.05, 1.05))

func _on_mouse_exited():
	change_scale(Vector2(1, 1))

func _on_button_down():
	change_scale(Vector2(0.95, 0.95))

func _on_button_up():
	change_scale(Vector2(1, 1))
