extends Node3D

@export var space: SimulationSpace

@export var available_agents: Array[Agent] = []

@export var available_actions : Array[Action] # dummy actions to copy and modify


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
	print_available_actions()
func print_available_actions():
	for a in available_agents:
		print(a)
		var actions := generate_all_actions(a)
		for action in actions:
			print("  ->" + action._to_string())
		
		print("\n")

func broad_research():
	space.actions = {}
	
	
