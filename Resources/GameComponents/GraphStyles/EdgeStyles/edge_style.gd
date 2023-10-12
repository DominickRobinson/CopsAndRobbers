extends Resource
class_name EdgeStyle


@export_enum("skin", "color") var mode = "skin"

@export_category("Skins")
@export var undirected_skin : Texture2D
@export var directed_skin : Texture2D
@export var reflexive_skin : Texture2D

@export_category("Other")
@export var default_color : Color = Color(0,0,0)
@export var width_px : float = 30.0
@export var border_width_px : float = 1.0
@export var show_reflexive_loop : bool = false
@export var show_directed_arrow : bool = false
