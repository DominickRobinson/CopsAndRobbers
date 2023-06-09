extends Button


@export var audio_name : String = ""

@export var one_at_a_time : bool = true

var can_play = true

func _ready():
	pressed.connect(_on_press)


func _on_press():
	if not one_at_a_time: 
		SoundManager.play_sound(audio_name)
	else:
		if not can_play: return
		can_play = false
		var player = SoundManager.play_sound(audio_name)
		disabled = true
		await player.finished
		can_play = true
		disabled = false
	
