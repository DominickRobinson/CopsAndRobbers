class_name Level
extends Node2D

signal level_ready

@export var game_resource : Game
var game_theme : GameTheme
var game_rules : GameRules
var vertex_style_resource : VertexStyle
var edge_style_resource : EdgeStyle

@export_file("*") var graph_path
@export var agent_resource : Resource


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

@export_file("*") var next_level_path
@onready var next_level_button : NextLevelButton = $CanvasLayer/GameOverScreen/CenterContainer/VBoxContainer/NextLevelButton

func _ready():
	
	
	game_theme = game_resource.game_theme
	game_rules = game_resource.game_rules
	
	background.texture = game_theme.background_skin
	
	await graph.load_graph(graph_path)
	await graph.refresh()
	
	if next_level_path == null: 
		next_level_button.hide()
	
	#get strategies
	cop_script = game_resource.cop_script
	robber_script = game_resource.robber_script

#	cop_script = load(game_resource.cop_script_path)
#	robber_script = load(game_resource.robber_script_path)
	
	#load graph
	graph.edge_style_resource = edge_style_resource
	graph.vertex_style_resource = vertex_style_resource
	
	#create all agents
	for i in game_rules.number_of_cops:
		var new_cop = agent_resource.instantiate() as Agent
		new_cop.name = "Cop " + str(i+1)
		new_cop.mode = "Cop"
		new_cop.set_sprite(game_theme.cop_skin)
		
		if game_rules.cop_arsonist: new_cop.arsonist = true
		
		cops.add_child(new_cop)
	for i in game_rules.number_of_robbers:
		var new_robber = agent_resource.instantiate() as Agent
		new_robber.name = "Robber " + str(i+1)
		new_robber.mode = "Robber"
		new_robber.set_sprite(game_theme.robber_skin)
		
		if game_rules.robber_arsonist: new_robber.arsonist = true
		
		robbers.add_child(new_robber)
	
	var agents : Array = cops.get_children()
	agents.append_array(robbers.get_children())
	
	for a in agents:
		a.travel_time = game_theme.agent_travel_time
	
	#tracks states
	var first_state
	var prev_state : State

	#creates all cop movement scripts
	for i in game_rules.number_of_cops:
		#duplicates if speed is greater
		for j in game_rules.cop_speed:
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
	for i in game_rules.number_of_robbers:
		#duplicates if speed is greater
		for j in game_rules.robber_speed:
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
	print(state is State)
	print("script: ", script)
	state.set_script(script)
	print(state is State)
	state = state as State
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
