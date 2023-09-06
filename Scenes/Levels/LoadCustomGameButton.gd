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

@export var cop_number_button : SpinBox
@export var robber_number_button : SpinBox
@export var cop_speed_button : SpinBox
@export var robber_speed_button : SpinBox
@export var agent_travel_time_button : SpinBox
@export var cop_arsonist_button : CheckButton
@export var robber_arsonist_button : CheckButton

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








#	var node_to_save = $Node2D
#
#	var scene = PackedScene.new()
#
#	scene.pack(node_to_save)
#
#	ResourceSaver.save(scene, "res://MyScene.tscn")


func _on_pressed():
	var level_pack = LevelPack.new()
	var game_resource = Game.new()
	
	var game_theme = GameTheme.new()
	var game_rules = GameRules.new()
	var cop_script : Script = null
	var robber_script : Script = null
	
	
