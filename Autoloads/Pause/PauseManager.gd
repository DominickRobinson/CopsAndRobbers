extends CanvasLayer

var paused = false

@export var pause_menu : Control

func _ready():
	unpause()


func pause():
	paused = true
	pause_menu.show()

func unpause():
	pause_menu.hide()
	paused = false

func toggle_pause():
	if paused:
		unpause()
	else:
		pause()
