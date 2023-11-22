extends HSlider




@export var audio_bus_name := "Master"

@onready var _bus := AudioServer.get_bus_index(audio_bus_name)


func _ready() -> void:
	value = db_to_linear(AudioServer.get_bus_volume_db(_bus))
	value_changed.connect(_on_value_changed)


func _on_value_changed(new_value: float) -> void:
	# cursed audio
	if new_value == 1.00:
		new_value *= 100
	if audio_bus_name == "Sound":
		SoundManager.change_volume_sound(new_value)
	elif audio_bus_name == "Music":
		SoundManager.change_volume_music(new_value)
