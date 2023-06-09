class_name StateMachine
extends Node

signal state_changed
signal game_over

@export var label : Label
@export var graph : Graph

@export var first_state : State

@export var cop_win_screen : Control
@export var robber_win_screen : Control
@export var game_over_screen : Control


var curr_state : State :
	set(value):
		if value != curr_state or curr_state != null:
			state_changed.emit()
		curr_state = value

func _ready():
	
	await graph.created
	
	for c in get_children():
		if not (c is State):
			continue
		c = c as State
		c.state_entered.connect(set.bind("curr_state", c))
	
	first_state.activate()


func _process(delta):
	
	if is_instance_valid(label):
		label.text = "State: "
		if is_instance_valid(curr_state): 
			label.text += str(curr_state.name)
		else:
			label.text += "none"


func end():
	curr_state.deactivate()
	game_over_screen.show()
	game_over.emit()
	print("end")


func cop_win():
	end()
	cop_win_screen.show()
	print("copwin")

func robber_win():
	end()
	robber_win_screen.show()
	print("robberwin")
