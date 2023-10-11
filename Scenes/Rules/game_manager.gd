extends Node

signal game_start
signal game_over

@export var state_machine : StateMachine

@export var graph : Graph


@export var game_over_screen : Control
@export var game_over_label : Label

@export var next_level_button : NextLevelButton

var cops :
	get: 
		return get_tree().get_nodes_in_group("Cops")
var robbers:
	get:
		return get_tree().get_nodes_in_group("Robbers")


func _ready():
	await get_parent().level_ready
	
#	graph.created.connect(emit_signal.bind("game_start"))
	game_start.emit()
	
	

func cop_win():
	game_over_label.text = "Cops win!"
	next_level_button.show()
	end()

func robber_win():
	game_over_label.text = "Robbers win..."
	next_level_button.hide()
	end()

func end():
	if is_instance_valid(state_machine):
		state_machine.end()
	
	game_over_label.text += "\nTurns taken: " + str(state_machine.turn)
	game_over_screen.modulate = Color(1,1,1,0)
	game_over_screen.show()
	var tween = create_tween()
	tween.tween_property(game_over_screen, "modulate", Color(1,1,1,1), 0.5)
	


func forfeit():
	if state_machine.curr_state.agent.is_cop(): robber_win()
	elif state_machine.curr_state.agent.is_robber(): cop_win()
