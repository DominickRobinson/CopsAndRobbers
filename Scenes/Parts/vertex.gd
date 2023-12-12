class_name Vertex
extends GraphComponent


signal moved


@export var style_resource : Resource:
	set(value):
		style_resource = value
		if is_node_ready(): set_resource()

#text label to be displayed if required
@export var text : String = ""

@export var label : Label
@export var scr_label : Label
@export var anim : AnimationPlayer

@onready var sprite = $Sprite2D
@onready var fire_sprite = $FireSprite

var index : int = -1 :
	set(value):
		index = value
		label.text = str(index)
		name = "Vertex " + str(index)
	

var strict_corner_ranking : int = 0 :
	set(value):
		strict_corner_ranking = value
		scr_label.text = str(strict_corner_ranking)

var is_top : bool = false

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

var moving = false

var old_position : Vector2

var highlighted = false




func _ready():
	super._ready()
	old_position = position
	selected.connect(_on_selected)
	sprite.texture_changed.connect(check_if_set_default_skin)
	vertex_container = get_parent()
	set_text()
	
#	selected.connect(anim.play.bind("selected"))
#	deselected.connect(anim.play.bind("RESET"))
	selected.connect(set_skin)
	
	set_resource()
	fire_sprite.hide()




func set_resource():
	sprite.texture = style_resource.default_skin


func _unhandled_input(_event):
	if editable:
		if Input.is_action_just_pressed("select"):
			await get_tree().process_frame
			if mouse_inside_area:
				drag()
		if Input.is_action_just_released("select"):
			draggable = false
			deselected.emit()
			if (old_position - position).length() > 5:
				moved.emit()
#				print("moved")
			moving = false
	
	if Input.is_action_just_released("select") and selectable:
		await get_tree().process_frame
		if mouse_inside_area:
			selected.emit()
	
#		if Input.is_action_just_pressed("delete") and mouse_inside_area:
#			remove()


func _process(_delta):
	
	if highlighted:
		modulate = Color.BLUE
	else:
		modulate = Color.WHITE
	
	set_text()
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
#	label.text += "SCR: " + str(strict_corner_ranking) 
#	label.text = str(strict_corner_ranking)
#	label.text = str(self)
	label.text = str(index)
#	label.text = ""
	pass



func get_neighbors():
	return neighbors

func get_occupents():
	return occupents


func burn():
	var graph = get_tree().get_first_node_in_group("Graphs") as Graph
	for nbor in neighbors:
		graph.remove_edge_given_vertices(self, nbor, true)
	
	graph.refresh()
#	fire_sprite.show()
	sprite.texture = style_resource.burnt_skin
	burnt = true

func highlight():
	modulate = Color.CYAN
	highlighted = true

func unhighlight():
	modulate = Color.WHITE
	highlighted = false

func emphasize():
	anim.play("emphasize")

func deemphasize():
	anim.play("RESET")

func check_if_set_default_skin():
	if sprite.texture == null: sprite.texture = style_resource.default_skin

func set_skin():
	if not editable:
		if not can_change_skin: return
		var cop_present = false
		var robber_present = false
		for o in occupents:
			o = o as Agent
			if o.is_robber(): if not o.captured: robber_present = true
			if o.is_cop(): cop_present = true
		
		if cop_present and robber_present: sprite.texture = style_resource.both_skin
		elif cop_present: sprite.texture = style_resource.cop_skin
		elif robber_present: sprite.texture = style_resource.robber_skin
		else: 
			if not burnt and mouse_inside_area and selectable: sprite.texture = style_resource.hovering_skin
			else: sprite.texture = style_resource.default_skin
		
		if burnt: sprite.texture = style_resource.burnt_skin
	
	else:
		pass

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


func show_strict_corner_ranking(show_scr:bool=true):
#	scr_label.text = "SCR: " + str(strict_corner_ranking)
	scr_label.visible = show_scr


func is_moving():
	return moving

func is_isolated():
	return strict_corner_ranking == -1



var net_force : Vector2 = Vector2.ZERO
func add_force(force : Vector2 = Vector2.ZERO):
	net_force += force
func apply_force(delta):
	var d = net_force * delta
	position += d
	net_force *= 0
	return d
#func _physics_process(delta):
#	apply_force(delta)

func drag():
	draggable = true
	mouse_offset = global_position - get_global_mouse_position()
#	print("Trying to move ", name, "    offset: ", mouse_offset, "    old position: ", old_position)
	moving = true
	old_position = position
