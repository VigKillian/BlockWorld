extends Node3D

@export var space: SimulationSpace

@export var available_agents: Array[Agent] = []

@export var available_actions : Array[Action] # dummy actions to copy and modify


func generate_all_ints(range: Array) -> Array[int]:
	var res: Array[int]
	
	var v: int = range[0]
	while v < range[1]:
		res.append(v)
		v += range[2]
	return res

func generate_all_vec3i(range: Array) -> Array[Vector3i]:
	var res: Array[Vector3i]
	
	var v: Vector3i = range[0]
	while v.x < range[1][0]:
		while v.y < range[1][1]:
			while v.z < range[1][2]:
				res.append(v)
				v.z += range[2][2]
			v.y += range[2][1]
		v.x += range[2][0]
	return res

func generate_all_actions(agent: Agent) -> Array[Action]:
	var res: Array[Action] = []
	
	for model_action in available_actions:
		#TODO check if action is compatible and possible for actor
		
		for parameter in model_action.ranges.keys():
			
			if model_action.get(parameter) is int:
				generate_all_ints(model_action.ranges[parameter])
			if model_action.get(parameter) is Vector3i:
				generate_all_vec3i(model_action.ranges[parameter])
	
	return res;


func broad_research():
	space.actions = {}
	
	
