extends Node3D


@export var space: SimulationSpace

@export var available_agents: Array[Agent] = []



func broad_research():
	space.actions = {}
	
	
