extends Resource
class_name Instruction


var instr_script: Script = null

@export_multiline var code: String

# advanced : scripts must have a main () function and get 
@export var advanced := false

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


# Available functions. TODO : Other instructions available aswell
