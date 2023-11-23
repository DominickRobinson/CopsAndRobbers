extends Button


@export_category("Buttons")
@export var cop_strategy_button : OptionButton
@export var robber_strategy_button : OptionButton
@export var cop_skin_button : OptionButton
@export var robber_skin_button : OptionButton
@export var vertex_style_button : OptionButton
@export var edge_style_button : OptionButton
@export var background_image_button : OptionButton
@export var music_button : OptionButton

#@export var strategy_dict : Dictionary
#@export var cop_skin_dict : Dictionary
#@export var robber_skin_dict : Dictionary
#@export var vertex_style_dict : Dictionary
#@export var edge_style_dict : Dictionary
#@export var background_dict : Dictionary
#@export var music_dict : Dictionary


@export var cop_number_button : SpinBox
@export var robber_number_button : SpinBox
@export var cop_speed_button : SpinBox
@export var robber_speed_button : SpinBox
@export var agent_travel_time_button : SpinBox
@export var cop_arsonist_button : CheckButton
@export var robber_arsonist_button : CheckButton

@export var load_graph_button : Button

@export_category("Variables")
@export var cop_strategy : Script
@export var robber_strategy : Script
@export var cop_skin : Texture2D
@export var robber_skin: Texture2D
@export var vertex_style : VertexStyle
@export var edge_style : EdgeStyle
@export var background_image : Texture2D
@export var music : AudioStream = null

@export var cop_number : int = 1
@export var robber_number : int = 1
@export var cop_speed : int = 1
@export var robber_speed : int = 1
@export var agent_travel_time : float = 0.5
@export var cop_arsonist : bool = false
@export var robber_arsonist : bool = false 

@export var graph_path : String


#	var node_to_save = $Node2D
#
#	var scene = PackedScene.new()
#
#	scene.pack(node_to_save)
#
#	ResourceSaver.save(scene, "res://MyScene.tscn")


func _on_pressed():
	if load_graph_button.get_graph_path() == "Choose graph folder":
		return
	
	var game_resource = Game.new()
	
	var game_theme = GameTheme.new()
	var game_rules = GameRules.new()
	game_resource.cop_script = get_cop_script()
	game_resource.robber_script = get_robber_script()
	
	var graph_path = load_graph_button.get_graph_path()
	
	game_theme.cop_skin = get_cop_skin()
	game_theme.robber_skin = get_robber_skin()
	game_theme.vertex_style_resource = get_vertex_style()
	game_theme.edge_style_resource = get_edge_style()
	game_theme.background_skin = get_bg_image()
	game_theme.music = get_music()
	game_theme.agent_travel_time = agent_travel_time_button.value
	
	game_rules.cop_speed = cop_speed_button.value
	game_rules.robber_speed = robber_speed_button.value
	game_rules.number_of_cops = cop_number_button.value
	game_rules.number_of_robbers = robber_number_button.value
	game_rules.cop_arsonist = cop_arsonist_button.button_pressed
	game_rules.robber_arsonist = robber_arsonist_button.button_pressed
	
	game_resource.game_rules = game_rules
	game_resource.game_theme = game_theme
	
#	await ResourceSaver.save(level_pack, "res://Custom/custom_game.tres")
	
	SceneManager.load_custom_level(game_resource, graph_path)


func get_cop_script():
	var str = "res://Resources/Scripts/move_"
	match cop_strategy_button.selected:
		0: str += "player"
		1: str += "lower_way"
		2: str += "zombie"
		3: str += "drunk"
		4: str += "drunk_nonsuicidal"
	str += ".gd"
	return load(str)

func get_robber_script():
	var str = "res://Resources/Scripts/move_"
	match robber_strategy_button.selected:
		0: str += "player"
		1: str += "higher_way"
		2: str += "survivor"
		3: str += "drunk"
		4: str += "drunk_nonsuicidal"
	str += ".gd"
	return load(str)

func get_cop_skin():
	var str = "res://Assets/Art/Characters/"
	match cop_skin_button.selected:
		0: str += "empty"
		1: str += "cop"
		2: str += "firefighter"
		3: str += "zombie"
	str += ".svg"
	return load(str)

func get_robber_skin():
	var str = "res://Assets/Art/Characters/"
	match robber_skin_button.selected:
		0: str += "empty"
		1: str += "ninja"
		2: str += "arsonist"
		3: str += "survivor"
	str += ".svg"
	return load(str)

func get_vertex_style():
	var str = "res://Resources/GameComponents/GraphStyles/VertexStyles/"
	match edge_style_button.selected:
		0: str += "vertex_style_basic"
		1: str += "vertex_style_firefighter_arsonist"
	str += ".tres"
	return load(str)

func get_edge_style():
	var str = "res://Resources/GameComponents/GraphStyles/EdgeStyles/"
	match edge_style_button.selected:
		0: str += "edge_style_basic"
		1: str += "edge_style_basic_no_loop"
	str += ".tres"
	return load(str)

func get_bg_image():
	var str = "res://Assets/Art/Backgrounds/"
	match background_image_button.selected:
		0: str += "white.png"
		1: str += "light_gray.png"
		2: str += "dark_gray.png"
		3: str += "black.png"
		4: str += "concrete2.JPEG"
		5: str += "grass3.jpg"
	return load(str)

func get_music():
	var str = "res://Assets/Music/"
	match music_button.selected:
		0: return null
		1: str += "cops_and_robbers_music.wav"
		2: str += "arsonist.wav"
		3: str += "Start Up.mp3"
		4: str += "Editor.mp3"
	return load(str)

