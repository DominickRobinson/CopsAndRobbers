extends Button


func _ready():
	toggled.connect(_change_text)
#	toggled.emit(false)

func _change_text(down):
	if down:
		text = "Hide advanced controls"
	else:
		text = "Show advanced controls"
