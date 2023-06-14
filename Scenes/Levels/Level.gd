class_name Level
extends Node2D

signal level_ready

@export_file("*") var graph_path
@export var number_of_cops : int = 1
@export var number_of_robbers : int = 1
@export_enum("player", "drunk", "lower way", "zombie") var cop_strategy : String = "player"
@export_enum("player", "drunk", "higher way") var robber_strategy : String = "player"

@export_enum("person", "cop", "cop-m", "cop-f", "robber", 
				"zombie", "zombie-m", "zombie-f") var cop_character : String = "person"
@export_enum("person", "cop", "cop-m", "cop-f", "robber", 
				"zombie", "zombie-m", "zombie-f") var robber_character : String = "person"

@export_category("Custom games")
@export_group("Resources")
@export var agent_resource : Resource
@export var player_script : Script
@export var drunk_script : Script
@export var cop_lower_way_script : Script
@export var robber_higher_way_script : Script
@export var cop_zombie_script : Script


@export_group("Assets")
@export_file("*.svg") var cop_sprite
@export_file("*.svg") var robber_sprite
@export_file("*.svg") var empty_vertex_sprite
@export_file("*.svg") var occupied_vertex_sprite
@export_file("*.svg") var directed_edge_sprite
@export_file("*.svg") var undirected_edge_sprite
@export_file("*.svg") var reflexive_edge_sprite


var cop_script : Script
var robber_script : Script

@export_category("Nodes")
@export var graph : Graph
@export var agents : Node2D
@export var cops : Node2D
@export var robbers : Node2D
@export var game_manager : Node
@export var state_machine : StateMachine


func _ready():
	
	#get strategies
	cop_script = get_move_script(cop_strategy)
	robber_script = get_move_script(robber_strategy)
	
	#load graph
	graph.load_graph(graph_path)
	
	#create all agents
	for i in number_of_cops:
		var new_cop = agent_resource.instantiate() as Agent
		new_cop.name = "Cop" + str(i)
		new_cop.mode = "Cop"
		new_cop.character = cop_character
		cops.add_child(new_cop)
	for i in number_of_robbers:
		var new_robber = agent_resource.instantiate() as Agent
		new_robber.name = "Robber" + str(i)
		new_robber.mode = "Robber"
		new_robber.character = robber_character
		robbers.add_child(new_robber)
	
	#tracks states
	var first_state
	var prev_state : State

	#creates all cop movement scripts
	for i in number_of_cops:
		var new_state = create_state(cop_script)
		new_state.name = "CopMove" + str(i)
		if is_instance_valid(prev_state):
			prev_state.next_state = new_state
		else:
			first_state = new_state
		new_state.agent = cops.get_children()[i]
		state_machine.add_child(new_state)
		prev_state = new_state
	
	#creates all robber movement scripts
	for i in number_of_robbers:
		var new_state = create_state(robber_script)
		new_state.name = "RobberMove" + str(i)
		prev_state.next_state = new_state
		new_state.agent = robbers.get_children()[i]
		state_machine.add_child(new_state)
		prev_state = new_state

	#loops the state machine
	prev_state.next_state = first_state
	state_machine.first_state = first_state
	
	level_ready.emit()

func create_state(script : Variant) -> State:
	var state = State.new()
	state.set_script(script)
	return state


func get_move_script(strategy:String) -> Script:
	match strategy:
		"player":
			return player_script
		"drunk":
			return drunk_script
		"lower way":
			return cop_lower_way_script
	
	return drunk_script
