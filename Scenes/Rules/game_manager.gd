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
@export var hint_button : Button
@export var buttons_container : VBoxContainer


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
	
	state_machine.state_entered.connect(_on_state_entered)
	
	#if first time in first state
	if state_machine.curr_state == state_machine.first_state:
		_on_state_entered()
	
	buttons_container.modulate = Color(1,1,1,0)


func _on_state_entered():
	print("State changed")
	#shows/hides hint button depending on if a player is moving
	print(state_machine.get_current_state().name)
	var agent = state_machine.get_agent() as Agent
	print("Agent: ", agent.name)
	
	if agent.is_player():
		print(" is player")
		if agent.is_cop():
			print(" is cop")
			hint_button.pressed.connect(_on_get_best_cop_move)
			agent.departed.connect(_on_player_cop_departed)
			hint_button.disabled = false
		else:
			hint_button.disabled = true
	else:
		hint_button.disabled = true

func _on_player_cop_departed():
	hint_button.pressed.disconnect(_on_get_best_cop_move)


func _on_get_best_cop_move():
	hint_button.pressed.disconnect(_on_get_best_cop_move)
	hint_button.disabled = true
	print("pressed")
	var agent = state_machine.get_agent() as Agent
	var best_move = graph.get_best_cop_move(agent) as Vertex
	for v in graph.get_vertices():
		v = v as Vertex
		if v == best_move:
			best_move.emphasize()
		else:
			v.deemphasize()


func cop_win():
	game_over_label.text = "Cops win!"
#	next_level_button.show()
	await end()
	
	if state_machine.turn <= graph.capture_time:
		await star_container.show_stars(3)
	elif state_machine.turn <= 3 * graph.capture_time:
		await star_container.show_stars(2)
	else:
		await star_container.show_stars(1)
	
	await create_tween().tween_property(buttons_container, "modulate", Color(1,1,1,1), 0.5).finished
	
	

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




#func forfeit():
#	if state_machine.curr_state.agent.is_cop(): robber_win()
#	elif state_machine.curr_state.agent.is_robber(): cop_win()

func get_agent():
	return state_machine.get_agent()
