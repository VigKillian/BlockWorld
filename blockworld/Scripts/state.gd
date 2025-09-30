class_name Step extends Resource


var action
var agent: Agent
var state: Dictionary

var parent : Step
var subSteps : Array[Step]

func retrievePath() -> Array[Step]:
	if(parent != null):
		var res = parent.retrievePath()
		res.append(self)
		return res
	return []

func equals(other: Step) -> bool:
	var s1 = str(action) + str(agent) + str(state)
	var s2 = str(other.action) + str(other.agent) + str(other.state)
	return s1 == s2

func addSubStep(step: Step):
	subSteps.append(step)
	step.parent = self

func save(path: String = "res://data/graph.dat"):
	var jsonData = serialize()
	var jsonString := JSON.stringify(jsonData, "\t")
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(jsonString)

func serialize():
	var jsonData : Dictionary
	
	jsonData["action"] = action
	jsonData["agent"] = agent
	jsonData["state"] = state
	var subStepsData: Array
	for sub in subSteps:
		subStepsData.append(sub.serialize())
	jsonData["sub_steps"] = subStepsData
	return jsonData

func load(path: String = "res://data/graph.dat"):
	var file := FileAccess.open(path, FileAccess.READ)
	var jsonString = file.get_as_text()
	deserialize(JSON.parse_string(jsonString))
	
func deserialize(data: Dictionary):
	state = data["state"]
	action = data["action"]
	agent = data["agent"]
	var subStepsData = data["sub_steps"]
	for substep in subStepsData:
		subSteps.append(deserialize(substep))
	
