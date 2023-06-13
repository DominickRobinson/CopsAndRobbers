extends Node

signal game_start
signal game_over

@export var state_machine : StateMachine

@export var graph : Graph

@export var cop_win_screen : Control
@export var robber_win_screen : Control
@export var game_over_screen : Control

var cops :
	get: 
		return get_tree().get_nodes_in_group("Cops")
var robbers:
	get:
		return get_tree().get_nodes_in_group("Robbers")


func _ready():
	await get_parent().level_ready
	
	graph.created.connect(emit_signal.bind("game_start"))
	
	

func cop_win():
	end()
	cop_win_screen.show()

func robber_win():
	end()
	robber_win_screen.show()


func end():
	if is_instance_valid(state_machine):
		state_machine.end()
	
	await get_tree().create_timer(3.0).timeout
	game_over_screen.show()
