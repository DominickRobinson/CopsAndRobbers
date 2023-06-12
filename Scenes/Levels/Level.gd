class_name Level
extends Node2D


@export_group("Specifications")
@export_file("*.json") var graph_path
@export var number_of_cops : int = 1
@export var number_of_robbers : int = 1



@export_group("Resources")
@export_file("*.tscn") var graph_resource 
@export_file("*.tscn") var player_resource
@export_file("*.gd") var cop_script
@export_file("*.gd") var robber_script


@export_group("Rules")
@export_file("*.gd") var move_state
@export_file("*.gd") var check_for_captures
@export_file("*.gd") var check_for_cop_win




var graph : Graph
var cops : Node2D
var robbers : Node2D
var state_machine : StateMachine
var checks : Node


func _ready():
	
	#create level
	graph = graph_resource.instantiate()
	graph.load_graph(graph_path)
	add_child(graph)
	
	#create state machine
	state_machine = state_machine.new()
	add_child(state_machine)
	checks = Node.new()
	checks.name = "Checks"
	state_machine.add_child(checks)
	
	#create entity containers
	cops = Node2D.new()
	cops.name = "Cops"
	robbers = Node2D.new()
	robbers.name = "Robbers"
	
	#create all entities
	for i in number_of_cops:
		var new_cop = player_resource.instantiate()
		new_cop.set_script(cop_script)
		new_cop.name = "Cop" + str(i)
		cops.add_child(new_cop)
	for i in number_of_robbers:
		var new_robber = player_resource.instantiate()
		new_robber.set_script(robber_script)
		new_robber.name = "Robber" + str(i)
		robbers.add_child(new_robber)
	
	


func create_state(script : Variant) -> State:
	var state = State.new()
	state.set_script(script)
	return state
