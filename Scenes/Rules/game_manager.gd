extends Node

signal game_start
signal game_over

@export var state_machine : StateMachine

@export var graph : Graph


@export var game_over_screen : Control
@export var game_over_label : Label

@export var next_level_button : NextLevelButton

@export var stopwatch : Stopwatch
@export var star_container : StarContainer

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
	await end()
	
	if state_machine.turn <= graph.capture_time:
		await star_container.show_stars(3)
	elif state_machine.turn <= 2 * graph.capture_time:
		await star_container.show_stars(2)
	else:
		await star_container.show_stars(1)

func robber_win():
	game_over_label.text = "Robbers win..."
	next_level_button.hide()
	await end()

func end():
	if is_instance_valid(state_machine):
		state_machine.end()
		game_over_label.text += "\nTurns taken: " + str(state_machine.turn)
	
	if is_instance_valid(stopwatch):
		stopwatch.stop()
		game_over_label.text += "\nTime taken: " + stopwatch.get_time_string()
	
	game_over_screen.modulate = Color(1,1,1,0)
	game_over_screen.show()
	var tween = create_tween() as Tween
	tween.tween_property(game_over_screen, "modulate", Color(1,1,1,1), 0.5)
	
	await tween.finished
	
	return true




func forfeit():
	if state_machine.curr_state.agent.is_cop(): robber_win()
	elif state_machine.curr_state.agent.is_robber(): cop_win()
