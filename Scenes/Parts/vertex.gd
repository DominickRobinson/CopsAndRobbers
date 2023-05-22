class_name Vertex
extends GraphComponent


#text label to be displayed if required
@export var text : String = ""

@onready var label = $Label

var index : int = -1

var mouse_offset = Vector2.ZERO
var mouse_inside_area = false


func _ready():
	label.text = str(index)

func _unhandled_input(event):
	if editable:
		if Input.is_action_just_pressed("drag") and mouse_inside_area:
			mouse_offset = global_position - get_global_mouse_position()
			selected = true
		if Input.is_action_just_released("drag"):
			selected = false
		if Input.is_action_just_pressed("delete") and mouse_inside_area:
			remove()
	else:
		if Input.is_action_just_pressed("drag") and mouse_inside_area:
			start_line()
			print(1)
		if Input.is_action_just_released("drag") and mouse_inside_area:
			#end of new edge
			print(2)


func _process(_delta):
	if editable:
		if selected:
			follow_mouse()


func follow_mouse():
	global_position = get_global_mouse_position() + mouse_offset
	global_position = snapped(global_position, Vector2(64,64))


func start_line():
#	draw_line(global_position, get_global_mouse_position(), Color.BLUE)
	pass

func _on_area_2d_mouse_entered():
	mouse_inside_area = true

func _on_area_2d_mouse_exited():
	mouse_inside_area = false


func remove():
	queue_free()
