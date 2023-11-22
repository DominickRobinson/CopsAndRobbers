extends TextureRect

@export var slider : HSlider

@export var muted : Texture2D
@export var low : Texture2D
@export var medium : Texture2D
@export var high : Texture2D
@export var maximum : Texture2D


# Called when the node enters the scene tree for the first time.
func _ready():
#	slider.value_changed.connect(change_icon)
	change_icon(slider.value)

func _process(_delta):
	change_icon(slider.value)

func change_icon(new_value):
	if new_value == 0.00:
		texture = muted
	elif new_value < .34:
		texture = low
	elif new_value < .67:
		texture = medium
	elif new_value < 1.00:
		texture = high
	elif new_value == 1.00:
		texture = maximum
