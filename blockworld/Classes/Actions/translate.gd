extends Action
class_name ActionTranslate
var ranges: Dictionary = {
	"p_delta" : [
		Vector3i(-3, -1, -3),
		Vector3i(3, 1, 3),
		Vector3i(1, 1, 1)
		]
}

@export var p_delta: Vector3i

const scale_factor := 0.5

func get_action_name() -> String:
	return "Translate"

func check_ranges():
	p_delta = p_delta.clamp(
		ranges["p_delta"][0],
		ranges["p_delta"][1],
	)
	p_delta = p_delta.snapped(ranges["p_delta"][2])

func exec(agent: Agent):
	check_ranges()
	agent.global_position += Vector3(p_delta) * scale_factor
