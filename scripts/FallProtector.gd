extends Area2D



func _on_body_entered(body):
	if body is Player:
		queue_free()
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
