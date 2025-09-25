
extends RigidBody3D
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
