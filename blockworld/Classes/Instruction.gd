@abstract
extends Resource
class_name Action


#var instr_script: Script = null

#@export var target_agent_name: StringName = ""

#@export_multiline var code: String


@abstract
func exec(agent: Agent)


func _to_string() -> String:
	var res: String = get_class().get_basename() +  "("
	var params = get_property_list()
	
	var first_property := true
	for param in params:
		if param.name.begins_with("p_"):
			if !first_property:
				res += ", "
			first_property = false
			res += param["name"].trim_prefix("p_") + "=" + str(get(param["name"]))
	
	res += ")"
	return res

# advanced : scripts must have a main () function and get 
# @export var advanced := false
"""
func compile():
	instr_script = GDScript.new()
	if (not advanced):
		instr_script.set_source_code("func main(agent: Agent, data: Dictionary):" + code)

	instr_script.reload()

func run(agent: Agent, data: Dictionary):
	if not instr_script:
		push_error("Instruction not compiled !")
		return
	var ref = RefCounted.new()
	ref.set_script(instr_script)
	return ref.main(agent, data)
"""


# Available functions. TODO : Other instructions available aswell
