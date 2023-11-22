class_name Stopwatch
extends Label

var time_elapsed := 0.0

var stopped = false

func _process(delta: float) -> void:
	if stopped:
		return
	
	time_elapsed += delta
	
	text = "Time elapsed: " + get_time_string()

func start():
	time_elapsed = 0
	stopped = false

func stop():
	stopped = true

func get_time_string():
	var s = str(round(time_elapsed/60)) + ":"
	if round(fmod(time_elapsed, 60)) < 10:
		s += "0"
	s += str(round(fmod(time_elapsed, 60)))
	return s
