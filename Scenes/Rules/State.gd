class_name State
extends Node

signal state_entered
signal state_exited

@onready var graph : Graph = get_parent().graph :
	get:
		if is_instance_valid(graph):
			return graph
		else:
			return null


@export var next_state : State

@export var agent : Agent
@export var target : Agent


func _ready():
	state_entered.connect(_on_state_entered)
	state_exited.connect(_on_state_exited)



func activate():
	state_entered.emit()

func deactivate():
	state_exited.emit()

func go_to_next_state(new_state:State = next_state):
	deactivate()
	new_state.activate()

func _on_state_entered():
	await get_tree().create_timer(.5)

func _on_state_exited():
	pass


func print_mapping(mapping:Dictionary):
	var output = "Mapping:\n"
	for vtx in mapping:
		output += str(vtx.index) + ":"
		for vm in mapping[vtx]:
			output += str(vm.index) + ","
		
		output = output.left(-1)
		output += "  "
	
	output += "\n"
	
	print(output)
