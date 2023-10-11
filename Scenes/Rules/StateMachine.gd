class_name StateMachine
extends Node

signal state_changed


@export var first_state : State

@export var label : Label


var cops : Array :
	get:
		return get_tree().get_nodes_in_group("Cops")

var robbers : Array :
	get:
		return get_tree().get_nodes_in_group("Robbers")


var curr_state : State :
	set(value):
		if value != curr_state or curr_state != null:
			state_changed.emit()
		curr_state = value

var graph : Graph :
	get:
		return get_parent().graph

var turn: 
	get:
		if is_instance_valid(first_state):
			return first_state.turn
		else:
			return -1


func _ready():
	await get_parent().game_start
	for c in get_children():
		if not (c is State):
			continue
		c = c as State
		c.state_entered.connect(set.bind("curr_state", c))
	
	first_state.activate()

#	first_state.state_entered.connect(increment_turn)
#
#var actually_started = false
#func increment_turn():
#	if not actually_started: actually_started = true
#	else: turn += 1

func _process(delta):
	
	label.text = "Optimal capture time: " + str(graph.capture_time) + "\n"
	
	if is_instance_valid(first_state):
		label.text += "Total turns: " + str(first_state.turn) + "\n"
	
	var vertices = graph.vertices
	var burnt = 0
	for vtx in vertices:
		if vtx.burnt: burnt += 1
	
	label.text += "Vertices burnt: " + str(burnt) + "\n"
	
	if curr_state:
		label.text += curr_state.agent.name + "'s turn!"
	else:
		label.text += "Uh oh..."

func end():
	curr_state.deactivate()
#	first_state.state_entered.disconnect(increment_turn)
	
