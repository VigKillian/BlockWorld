extends Action

static var ranges: Dictionary = {
	"p_degree" : [0, 270, 90], # min, max, step
	"p_axis" : [0, 2, 1]
}
@export var p_degree: int
@export var p_axis: int

func check_ranges():
	p_degree = clamp(p_degree, ranges["p_degree"][0], ranges["p_degree"][1])
	p_degree = snapped(p_degree, ranges["p_degree"][2])
	p_axis = clamp(p_axis, ranges["p_axis"][0], ranges["p_axis"][1])

func exec(agent: Agent):
	check_ranges()
