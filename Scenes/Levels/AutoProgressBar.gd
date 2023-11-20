extends ProgressBar


@export var thing_doer : DoTheThingButton


func _process(delta):
	value = min(value+1, thing_doer.progress)
