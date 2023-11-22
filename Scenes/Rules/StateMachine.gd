class_name StateMachine
extends Node

signal state_entered

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
		var old_state = curr_state
		curr_state = value
		if curr_state != old_state:
			state_entered.emit()

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
		c.state_entered.connect(emit_signal.bind(state_entered))
	
	first_state.activate()


#	first_state.state_entered.connect(increment_turn)
#
#var actually_started = false
#func increment_turn():
#	if not actually_started: actually_started = true
#	else: turn += 1

func _process(_delta):
	
	label.text = "Optimal capture time: " + str(graph.capture_time) + "\n"
	
	if is_instance_valid(first_state):
		label.text += "Total turns: " + str(first_state.turn) + "\n"
	
	var vertices = graph.vertices
	var burnt = 0
	for vtx in vertices:
		if vtx.burnt: burnt += 1
	
#	label.text += "Vertices burnt: " + str(burnt) + "\n"
	
#	if curr_state:
#		label.text += curr_state.agent.name + "'s turn!"
#	else:
#		label.text += "Uh oh..."

func end():
	curr_state.deactivate()
#	first_state.state_entered.disconnect(increment_turn)

func get_agent():
	if is_instance_valid(curr_state):
		return curr_state.agent
	else:
		return null

func get_current_state():
	return curr_state
