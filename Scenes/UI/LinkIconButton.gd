class_name LinkIconButton
extends Button

@export var url : String = ""


func _ready():
	pressed.connect(_on_pressed)


func _on_pressed():
	if url != "":
		OS.shell_open(url)
