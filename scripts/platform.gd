class_name Platform extends TileMap


func on_hit(collision: KinematicCollision2D, normal: Vector2):
	var local_position = to_local(collision.get_position())
	var cell_position = local_to_map(local_position - normal)
	
	set_cell(0, cell_position, -1)

