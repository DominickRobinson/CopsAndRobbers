class_name Vertex
extends GraphComponent


signal moved


#text label to be displayed if required
@export var text : String = ""

@export var label : Label
@export var anim : AnimationPlayer

var index : int = -1

var strict_corner_ranking : int = 0


var mouse_offset = Vector2.ZERO

var draggable = false

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


func _ready():
	super._ready()
	vertex_container = get_parent()
	set_text()
	
	selected.connect(anim.play.bind("selected"))
	deselected.connect(anim.play.bind("RESET"))


func _unhandled_input(_event):
	if editable:
		if Input.is_action_just_pressed("select") and mouse_inside_area:
			mouse_offset = global_position - get_global_mouse_position()
		if Input.is_action_just_released("select"):
			draggable = false
			deselected.emit()
			moved.emit()
	
	if mouse_inside_area and Input.is_action_just_pressed("select") and selectable:
#		print(self.name, " selected")
		selected.emit()
	
#		if Input.is_action_just_pressed("delete") and mouse_inside_area:
#			remove()


func _process(delta):
	set_text()
	if draggable: follow_mouse()


func follow_mouse():
	global_position = get_global_mouse_position() + mouse_offset
#	global_position = snapped(global_position, Vector2(64,64))



func set_text():
	label.text = "Index: " + str(index) + "\n"
	label.text += "SCR: " + str(strict_corner_ranking) 
#	label.text = str(strict_corner_ranking)
#	label.text = str(self)
#	label.text = str(index)

func get_neighbors():
	return neighbors

func get_occupents():
	return occupents


func burn():
	pass
