class_name Vertex
extends GraphComponent


signal moved


@export var style_resource : Resource

#text label to be displayed if required
@export var text : String = ""

@export var label : Label
@export var anim : AnimationPlayer

@export var sprite : Sprite2D
@export var fire_sprite : Sprite2D

var index : int = -1

var strict_corner_ranking : int = 0


var mouse_offset = Vector2.ZERO

var draggable = false
var burnt = false
var can_change_skin = true

@onready var vertex_container

var neighbors : Array = []

var selectable :
	set(value):
		if value:
			anim.play("selectable")
		else:
			anim.play("RESET")
		selectable = value

var occupents : Array = []
var old_occupents : Array = []


func _ready():
	super._ready()
	selected.connect(_on_selected)
	sprite.texture_changed.connect(check_if_set_default_skin)
	vertex_container = get_parent()
	set_text()
	
	selected.connect(anim.play.bind("selected"))
	deselected.connect(anim.play.bind("RESET"))
	selected.connect(set_skin)
	
	fire_sprite.hide()
	sprite.texture = style_resource.default_skin


func _unhandled_input(_event):
	if editable:
		if Input.is_action_just_pressed("select") and mouse_inside_area:
			mouse_offset = global_position - get_global_mouse_position()
		if Input.is_action_just_released("select"):
			draggable = false
			deselected.emit()
			moved.emit()
	
	if mouse_inside_area and Input.is_action_just_pressed("select") and selectable:
		selected.emit()
	
#		if Input.is_action_just_pressed("delete") and mouse_inside_area:
#			remove()


func _process(delta):
#	set_text()
	if draggable: follow_mouse()
	
#	if old_occupents != occupents:
#		set_skin()
#		old_occupents = occupents
	
	set_skin()

func follow_mouse():
	global_position = get_global_mouse_position() + mouse_offset
#	global_position = snapped(global_position, Vector2(64,64))



func set_text():
#	label.text = "Index: " + str(index) + "\n"
#	label.text = "SCR: " + str(strict_corner_ranking) 
#	label.text = str(strict_corner_ranking)
#	label.text = str(self)
#	label.text = str(index)
	label.text = ""

func get_neighbors():
	return neighbors

func get_occupents():
	return occupents


func burn():
	var graph = get_tree().get_first_node_in_group("Graphs") as Graph
	for nbor in neighbors:
		graph.remove_edge_given_vertices(self, nbor, true)
	
#	fire_sprite.show()
	sprite.texture = style_resource.burnt_skin
	burnt = true


func check_if_set_default_skin():
	if sprite.texture == null: sprite.texture = style_resource.default_skin

func set_skin():
	if not can_change_skin: return
	var has_cop = false
	var has_robber = false
	for o in occupents:
		o = o as Agent
		if o.is_robber(): if not o.captured: has_robber = true
		if o.is_cop(): has_cop = true
	
	if has_cop and has_robber: sprite.texture = style_resource.both_skin
	elif has_cop: sprite.texture = style_resource.cop_skin
	elif has_robber: sprite.texture = style_resource.robber_skin
	else: 
		if not burnt and mouse_inside_area and selectable: sprite.texture = style_resource.hovering_skin
		else: sprite.texture = style_resource.default_skin
	
	if burnt: sprite.texture = style_resource.burnt_skin

func _on_selected():
#	can_change_skin = false
#	sprite.texture = style_resource.selected_skin
#	await get_tree().create_timer(0.5).timeout
#	can_change_skin = true
	pass

func has_cop():
	for o in occupents:
		o = o as Agent
		if o.is_cop(): return true
	return false
