extends Node3D

@export var space: SimulationSpace

@export var available_agents: Array[Agent] = []
@export var goal : Area3D
@export var available_actions : Array[Action] # dummy actions to copy and modify

func initialize_agents(agents: Array[Agent]):
	available_agents = agents

func generate_all_ints(range: Array) -> Array[int]:
	var res: Array[int]
	
	var v: int = range[0]
	while v <= range[1]:
		res.append(v)
		v += range[2]
	return res

func generate_all_vec3i(range: Array) -> Array[Vector3i]:
	var res: Array[Vector3i]
	
	var v: Vector3i = range[0]
	while v.x <= range[1][0]:
		while v.y <= range[1][1]:
			while v.z <= range[1][2]:
				res.append(v)
				v.z += range[2][2]
			v.y += range[2][1]
			v.z = range[0][2]
		v.x += range[2][0]
		v.y = range[0][1]
	return res

func generate_all_actions(agent: Agent) -> Array[Action]:
	var res: Array[Action] = []
	
	for model_action in available_actions:
		#TODO check if action is compatible and possible for actor
		var param_values_arrays: Array[Array]
		for parameter in model_action.ranges.keys():
			if model_action.get(parameter) is int:
				param_values_arrays.push_back(generate_all_ints(model_action.ranges[parameter]))
			if model_action.get(parameter) is Vector3i:
				param_values_arrays.push_back(generate_all_vec3i(model_action.ranges[parameter]))
				
		var counters: Array[int] = []
		counters.resize(param_values_arrays.size())
		counters.fill(0)
		while counters[0] < param_values_arrays[0].size():
			var action := model_action.duplicate()
			for i in param_values_arrays.size():
				action.set(
					model_action.ranges.keys()[i],
					param_values_arrays[i][counters[i]]
					)
			res.push_back(action)
			
			# go to next arrangement
			counters[-1] += 1
			for i in range(counters.size()-1, 0, -1):
				if counters[i] >= param_values_arrays[i].size():
					counters[i] = 0
					counters[i-1] += 1
				else:
					break
			
	
	return res;

func _ready() -> void:
	distance_search(space,available_agents[0],0)

func print_available_actions():
	for a in available_agents:
		print(a)
		var actions := generate_all_actions(a)
		for action in actions:
			print("  ->" + action._to_string())
		
		print("\n")
		
func distance_search(s: SimulationSpace, target: Agent ,depth: int):
	# code a modifier bien evidemment je fais nimp (ça marche la)
	while not (target in goal.get_overlapping_bodies()) && not (target.global_basis.y.angle_to(Vector3(0, 0, 1)) == 0):
		await get_tree().create_timer(1.0).timeout
		var pos = target.global_position
		var min_dist : float = 10000.0
		var min_action : Action
		for a in generate_all_actions(target):
			if a is ActionTranslate:
				var test = (target.global_position + Vector3(a.p_delta)*0.5).distance_to(goal.global_position) + target.global_basis.y.angle_to(Vector3(0, 0, 1))
				if test < min_dist:
					min_dist = test
					min_action = a
			if a is ActionRotate:
				var new_up = target.global_basis.y.rotated(
					Vector3(
						a.p_axis == 0,
						a.p_axis == 1,
						a.p_axis == 2,
					),
					a.p_degree)
				var test = new_up.angle_to(Vector3(0,0,1)) + (target.global_position).distance_to(goal.global_position)
				if test < min_dist:
					min_dist = test
					min_action = a
		min_action.exec(target)
		print("Action choisie : ", min_action)
		
	print("TROUVE")
	print(target.global_basis.y.angle_to(Vector3(0, 0, 1)))

func broad_research(s: SimulationSpace, depth: int):
	if depth <=0:
		return false
	
	#if space = finish_state 
	
	var new_spaces : Array[SimulationSpace]
	var all_actions : Dictionary[Action, Agent]
	
	for agent in available_agents:
		var generated_actions := generate_all_actions(agent)
		for a in generated_actions:
			all_actions[a] = agent
	
	for action in all_actions.keys():
		var new_space : SimulationSpace = s.duplicate()
		new_space.actions[action] = all_actions[action]
		new_space.step_by_step_simulation()
		new_space.next_step() # sert à rien normalement
		new_spaces.append(new_space)
		
		
	for new_space in new_spaces:
		broad_research(new_space, depth-1)
	
	
	
