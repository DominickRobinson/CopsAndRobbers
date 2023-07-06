class_name Level
extends Node2D

signal level_ready

@export var ruleset_resource : Resource
@export var vertex_style_resource : Resource
@export var edge_style_resource : Resource
@export var theme_style_resource : Resource

@export_file("*") var graph_path
#@export var number_of_cops : int = 1
#@export var number_of_robbers : int = 1
#@export var cop_speed : int = 1
#@export var robber_speed : int = 1
#@export var cop_arsonist : bool = false
#@export var robber_arsonist : bool = false
#@export_enum("player", "drunk", "lower way", "zombie") var cop_strategy : String = "player"
#@export_enum("player", "drunk", "higher way") var robber_strategy : String = "player"
#
#@export_enum("person", 
#				"cop", "robber", 
#				"zombie", "survivor", "nuclear protection",
#				"firefighter", "arsonist",
#				"teacher", "student",
#				"health worker", "person sneezing into elbow", "person with medical mask",
#				"farmer", "pig",
#				"detective", "astronaut", "troll", "moai", 
#				"Santa Claus", "Mrs Claus", 
#				"Greta Thunberg", "trump") var cop_skin : String = "person"
#
#@export_enum("person", 
#				"cop", "robber", 
#				"zombie", "survivor", "nuclear protection",
#				"firefighter", "arsonist",
#				"teacher", "student",
#				"health worker", "person sneezing into elbow", "person with medical mask",
#				"farmer", "pig",
#				"detective", "astronaut", "troll", "moai", 
#				"Santa Claus", "Mrs Claus", 
#				"Greta Thunberg", "trump") var robber_skin : String = "person"

#@export_group("Custom games")
#@export_subgroup("Resources")
@export var agent_resource : Resource
#@export var player_script : Script
#@export var drunk_script : Script
#@export var cop_lower_way_script : Script
#@export var robber_higher_way_script : Script
#@export var zombie_lower_way_script : Script


#@export_subgroup("Assets")
#@export_file("*.svg") var cop_sprite
#@export_file("*.svg") var robber_sprite
#@export_file("*.svg") var empty_vertex_sprite
#@export_file("*.svg") var occupied_vertex_sprite
#@export_file("*.svg") var directed_edge_sprite
#@export_file("*.svg") var undirected_edge_sprite
#@export_file("*.svg") var reflexive_edge_sprite


var cop_script : Script
var robber_script : Script

#@export_group("Nodes")
@onready var graph : Graph = $Graph
@onready var agents : Node2D = $Agents
@onready var cops : Node2D = $Agents/Cops
@onready var robbers : Node2D = $Agents/Robbers
@onready var game_manager : Node = $GameManager
@onready var state_machine : StateMachine = $GameManager/StateMachine
@onready var background : Sprite2D = $ParallaxBackground/ParallaxLayer/Background

func _ready():
	
	background.texture = theme_style_resource.background_skin
	
	
	#get strategies
	cop_script = ruleset_resource.cop_script
	robber_script = ruleset_resource.robber_script
	
	#load graph
	graph.load_graph(graph_path)
	graph.edge_style_resource = edge_style_resource
	graph.vertex_style_resource = vertex_style_resource
	
	#create all agents
	for i in ruleset_resource.number_of_cops:
		var new_cop = agent_resource.instantiate() as Agent
		new_cop.name = "Cop" + str(i)
		new_cop.mode = "Cop"
		new_cop.set_sprite(ruleset_resource.cop_skin)
		
		if ruleset_resource.cop_arsonist: new_cop.arsonist = true
		
		cops.add_child(new_cop)
	for i in ruleset_resource.number_of_robbers:
		var new_robber = agent_resource.instantiate() as Agent
		new_robber.name = "Robber" + str(i)
		new_robber.mode = "Robber"
		new_robber.set_sprite(ruleset_resource.robber_skin)
		
		if ruleset_resource.robber_arsonist: new_robber.arsonist = true
		
		robbers.add_child(new_robber)
	
	var agents : Array = cops.get_children()
	agents.append_array(robbers.get_children())
	
	for a in agents:
		a.travel_time = theme_style_resource.agent_travel_time
	
	#tracks states
	var first_state
	var prev_state : State

	#creates all cop movement scripts
	for i in ruleset_resource.number_of_cops:
		#duplicates if speed is greater
		for j in ruleset_resource.cop_speed:
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
	for i in ruleset_resource.number_of_robbers:
		#duplicates if speed is greater
		for j in ruleset_resource.robber_speed:
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


#func get_move_script(strategy:String) -> Script:
#	match strategy:
#		"player":
#			return player_script
#		"drunk":
#			return drunk_script
#		"lower way":
#			return cop_lower_way_script
#		"higher way":
#			return robber_higher_way_script
#
#	return drunk_script
