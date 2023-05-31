class_name Vertex
extends GraphComponent



#text label to be displayed if required
@export var text : String = ""

@onready var label = $Label

var index : int = -1

var mouse_offset = Vector2.ZERO

var draggable = false

@onready var vertex_container


func _ready():
	super._ready()
	vertex_container = get_parent()
	set_text()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("select") and mouse_inside_area:
		selected.emit()
	
	if editable:
		if Input.is_action_just_pressed("select") and mouse_inside_area:
			mouse_offset = global_position - get_global_mouse_position()
			draggable = true
		if Input.is_action_just_released("select"):
			draggable = false
#		if Input.is_action_just_pressed("delete") and mouse_inside_area:
#			remove()


func _process(delta):
	set_text()
	if draggable: follow_mouse()


func follow_mouse():
	global_position = get_global_mouse_position() + mouse_offset
#	global_position = snapped(global_position, Vector2(64,64))



func set_text():
	label.text = str(index)
