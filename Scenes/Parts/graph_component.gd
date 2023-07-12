class_name GraphComponent
extends Node2D

signal selected
signal deselected
signal mouse_entered
signal mouse_exited

@export var area : Area2D

var editable = false
var mouse_inside_area = false




func _ready():
	area.mouse_entered.connect(_on_area_2d_mouse_entered)
	area.mouse_exited.connect(_on_area_2d_mouse_exited)





func remove():
	queue_free()

func _on_area_2d_mouse_entered():
	print("Mouse entered: ", self.name)
	mouse_inside_area = true
	mouse_entered.emit()

func _on_area_2d_mouse_exited():
	print("Mouse exited: ", self.name)
	mouse_inside_area = false
	mouse_exited.emit()
