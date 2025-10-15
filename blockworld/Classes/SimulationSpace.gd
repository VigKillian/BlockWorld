extends Node3D
class_name SimulationSpace

#@export var scene_children : Array[Node3D]

@export var actions: Dictionary[Action, Agent]
@export var winning_conditions: Dictionary[Agent, Area3D]

var current_step_index : int

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_accept")):
		save_scene_as_json()
		print("Données enregistrées")

func _ready() -> void:
	current_step_index = 0
	#step_by_step_simulation()
	#next_step()
	#step_by_step_simulation()
	#var sim := Simulator
	#start_simulation()
	print(actions)
	
func next_step():
	current_step_index += 1

func step_by_step_simulation():
	print("action start")
	#var rootStep:= Step.new()
	#var previousStep:= rootStep
	var next_actions := actions.keys()
	if current_step_index < len(next_actions):
		if not is_instance_valid(next_actions[current_step_index]): return
		next_actions[current_step_index].exec(actions[next_actions[current_step_index]])
		print("Action ", current_step_index, " exécutée")
		# sauvegarder scène
		var currentStep := Step.new()
		currentStep.agent = actions[next_actions[current_step_index]]
		currentStep.action = next_actions[current_step_index]
		
		#var state: Dictionary[Agent, Dictionary]
		#for agent in actions.values():
			#state[agent] = {"data" : agent.data}
			#state[agent]["transform"] = agent.global_transform 
		#currentStep.state = state
		#previousStep.addSubStep(currentStep)
		#previousStep = currentStep	
	#rootStep.save()

func start_simulation():
	print("action start")
	var rootStep:= Step.new()
	var previousStep:= rootStep
	var it:=0
	while it<actions.keys().size() && !check_final_state():
		var a = actions.keys()[it]
		
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
		it += 1
	
	rootStep.save()
	if check_final_state():
		print("Ouihi")
	else:
		print(":(")
	
func stop_simulation():
	pass

func save_scene_as_json():
	var json_dico : Array[Dictionary]
	
	for o in get_tree().get_nodes_in_group("scene_objects"):
		#print(o)
		#var color : Color = o.mesh.material.albedo_color
		var pos : String = str(o.position)
		var rota : String = str(o.rotation)
		var scl : String = str(o.scale)
		
		json_dico.append({"position" : pos, "rotation" : rota, "scale" : scl})
		
	var json_string := JSON.stringify(json_dico, "\t")
	#print(str(global_transform))
	var file = FileAccess.open("res://data/save_objects.dat", FileAccess.WRITE)
	#print("file : ", file)
	file.store_string(json_string)
		

func check_final_state() -> bool:
	var finalState = true
	for agent in winning_conditions.keys():
		var bodies = winning_conditions[agent].get_overlapping_bodies()
		var agentState = false
		for body in bodies:
			if body == agent:
				agentState = true
		finalState &= agentState
	
	return finalState
