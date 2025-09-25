extends Node3D
class_name SimulationSpace

#@export var scene_children : Array[Node3D]

@export var actions: Dictionary[Agent, Action]

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_accept")):
		save_scene_as_json()
		print("Données enregistrées")

func start_simulation():
	var previousStep: Step
	for a in actions.keys():
		actions[a].exec(a)
		await get_tree().create_timer(2.0)
		# sauvegarder scène
		var currentStep: Step
		currentStep.agent = a
		currentStep.action = actions[a]
		
		var state: Dictionary
		for agent in actions.keys():
			state[agent]["data"] = agent.data
			state[agent]["transform"] = agent.global_transform 
		currentStep.state = state
		if previousStep != null:
			currentStep.parent = previousStep
		previousStep = currentStep
		
		print("Action exécutée")
	
	previousStep.save()
	
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
		
		
