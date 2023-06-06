extends Button


@export var audio_name : String = ""

var can_play = true

func _ready():
	pressed.connect(_on_press)


func _on_press():
	if not can_play: return
	can_play = false
	var player = SoundManager.play_sound(audio_name)
	await player.finished
	can_play = true
	
