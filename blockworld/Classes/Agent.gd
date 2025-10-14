@tool
extends XRToolsPickable
class_name Agent


#var instructions: Array[Action] = []

var data: Dictionary

#var play = func ():
	#var data := {}
	#for instr in instructions:
	#	instr.execute(self, data)


# Available functions.

#func jump(strength: float):
	#apply_central_impulse(Vector3.UP * strength)


func wait():
	pass


func _on_released(pickable: Variant, by: Variant) -> void:
	global_position = global_position.snapped(Vector3(0.5, 0, 0.5))
	global_position.y = 2.5
	
	var snapped_rotation = Vector3(
		round(global_rotation.x / (PI / 2)) * (PI / 2),
		round(global_rotation.y / (PI / 2)) * (PI / 2),
		round(global_rotation.z / (PI / 2)) * (PI / 2)
	)
	global_rotation = snapped_rotation
