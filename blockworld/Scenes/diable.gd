extends MeshInstance3D


func look_player():
	var player = get_tree().get_nodes_in_group("player_body")[0]
	var dir = (global_position - player.global_position)
	dir.y = 0                          
	if dir.length_squared() == 0:
		return
	dir = dir.normalized()
	global_rotation.y = atan2(dir.x, dir.z)


func _physics_process(delta: float) -> void:
	look_player()

func move_to_player():
	return
