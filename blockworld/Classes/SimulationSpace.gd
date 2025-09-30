extends Node3D
class_name SimulationSpace

#@export var scene_children : Array[Node3D]

@export var actions: Dictionary[Action, Agent]

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_accept")):
		save_scene_as_json()
		print("Données enregistrées")

func _ready() -> void:
	start_simulation()
	print(actions)

func start_simulation():
	print("action start")
	var rootStep:= Step.new()
	var previousStep:= rootStep
	for a in actions.keys():
		if not is_instance_valid(a): continue
		a.exec(actions[a])
		await get_tree().create_timer(1.0).timeout
		print("Action exécutée")
		# sauvegarder scène
		var currentStep := Step.new()
		currentStep.agent = actions[a]
		currentStep.action = a
		
		var state: Dictionary[Agent, Dictionary]
		for agent in actions.values():
			state[agent] = {"data" : agent.data}
			state[agent]["transform"] = agent.global_transform 
		currentStep.state = state
		previousStep.addSubStep(currentStep)
		previousStep = currentStep
		
		await get_tree().create_timer(1.0).timeout
	
	rootStep.save()
	
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
		
		
