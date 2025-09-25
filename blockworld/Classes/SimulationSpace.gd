extends Node3D
class_name SimulationSpace

@export var scene_children : Array[Node3D]
@export var agents_list : Array[Agent]
var objects : Array[Node3D]

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_accept")):
		save_scene_as_json()
		print("Données enregistrées")

func start_simulation():
	pass
	
func stop_simulation():
	pass

func save_scene_as_json():
	var json_dico : Array[Dictionary]
	
	for o in get_tree().get_nodes_in_group("scene_objects"):
		print(o)
		#var color : Color = o.mesh.material.albedo_color
		var pos : String = str(o.position)
		var rota : String = str(o.rotation)
		var scl : String = str(o.scale)
		
		json_dico.append({"position" : pos, "rotation" : rota, "scale" : scl})
		
	var json_string := JSON.stringify(json_dico, "\t")
	print(str(global_transform))
	var file = FileAccess.open("res://data/save_objects.dat", FileAccess.WRITE)
	print("file : ", file)
	file.store_string(json_string)
		
		
